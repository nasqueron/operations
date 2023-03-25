#   -------------------------------------------------------------
#   Sentry configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Realm:          {{ realm }}
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/paas-docker/containers/files/sentry/etc/sentry.conf.py
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>


import hvac

from sentry.conf.server import *  # NOQA


#   -------------------------------------------------------------
#   Helper methods
#
#   The get_internal_network has been adapted from pynetlinux:
#   https://github.com/rlisagor/pynetlinux/blob/e3f16978855c6649685f0c43d4c3fcf768427ae5/pynetlinux/ifconfig.py#L197-L223
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def get_internal_network():
    import ctypes
    import fcntl
    import math
    import socket
    import struct

    iface = b"eth0"
    sockfd = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    ifreq = struct.pack(b"16sH14s", iface, socket.AF_INET, b"\x00" * 14)

    try:
        ip = struct.unpack(
            b"!I", struct.unpack(b"16sH2x4s8x", fcntl.ioctl(sockfd, 0x8915, ifreq))[2]
        )[0]
        netmask = socket.ntohl(
            struct.unpack(b"16sH2xI8x", fcntl.ioctl(sockfd, 0x891B, ifreq))[2]
        )
    except IOError:
        return ()
    base = socket.inet_ntoa(struct.pack(b"!I", ip & netmask))
    netmask_bits = 32 - int(round(math.log(ctypes.c_uint32(~netmask).value + 1, 2), 1))
    return "{0:s}/{1:d}".format(base, netmask_bits)


def read_secret(mount_point, prefix, key):
    secret = vault_client.secrets.kv.read_secret_version(
        mount_point=mount_point, path=prefix + "/" + key
    )
    return secret["data"]["data"]


def read_ops_secret(key):
    return read_secret("ops", "secrets", key)


def read_app_secret(key):
    return read_secret("apps", "sentry", key)


#   -------------------------------------------------------------
#   Authenticate to Vault
#
#   Credentials for PostgreSQL or the secret key are stored in Vault.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


vault_client = hvac.Client(
    url="{{ vault.addr }}", verify="/etc/sentry/certificates/nasqueron-vault-ca.crt"
)

vault_client.auth.approle.login(
    role_id="{{ vault.approle.roleID }}",
    secret_id="{{ vault.approle.secretID }}",
)


#   -------------------------------------------------------------
#   Sentry configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


INTERNAL_SYSTEM_IPS = (get_internal_network(),)

secret = read_ops_secret("{{ args.credentials.postgresql }}")
DATABASES = {
    "default": {
        "ENGINE": "sentry.db.postgres",
        "NAME": "postgres",
        "USER": secret["username"],
        "PASSWORD": secret["password"],
        "HOST": "{{ args.services.postgresql }}",
        "PORT": "",
    }
}

SENTRY_USE_BIG_INTS = True


#   -------------------------------------------------------------
#   General
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

REALM = "{{ realm }}"

SENTRY_SINGLE_ORGANIZATION = False

SENTRY_OPTIONS["system.event-retention-days"] = int(
    env("SENTRY_EVENT_RETENTION_DAYS", "90")
)

secret_key = read_ops_secret("{{ args.credentials.secret_key }}")
SENTRY_OPTIONS["system.secret-key"] = secret_key["password"]

GEOIP_PATH_MMDB = "/usr/local/share/geoip/GeoLite2-City.mmdb"


#   -------------------------------------------------------------
#   Redis
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


SENTRY_OPTIONS["redis.clusters"] = {
    "default": {
        "hosts": {
            0: {
                "host": "{{ args.services.redis }}",
                "password": "",
                "port": "6379",
                "db": "0",
            }
        }
    }
}

SENTRY_BUFFER = "sentry.buffer.redis.RedisBuffer"
SENTRY_QUOTAS = "sentry.quotas.redis.RedisQuota"
SENTRY_RATELIMITER = "sentry.ratelimits.redis.RedisRateLimiter"
SENTRY_DIGESTS = "sentry.digests.backends.redis.RedisBackend"


#   -------------------------------------------------------------
#   Queue - Celery
#
#   Reference: https://develop.sentry.dev/services/queue/
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


BROKER_URL = "redis://:{password}@{host}:{port}/{db}".format(
    **SENTRY_OPTIONS["redis.clusters"]["default"]["hosts"][0]
)


#   -------------------------------------------------------------
#   Caching
#
#     :: Redis
#     :: Memcached
#     :: Kafka
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


SENTRY_CACHE = "sentry.cache.redis.RedisCache"

CACHES = {
    "default": {
        "BACKEND": "django.core.cache.backends.memcached.MemcachedCache",
        "LOCATION": ["{{ args.services.memcached }}:11211"],
        "TIMEOUT": 3600,
    }
}

DEFAULT_KAFKA_OPTIONS = {
    "bootstrap.servers": "{{ args.services.kafka }}:9092",
    "message.max.bytes": 50000000,
    "socket.timeout.ms": 1000,
}
KAFKA_CLUSTERS["default"] = DEFAULT_KAFKA_OPTIONS

SENTRY_EVENTSTREAM = "sentry.eventstream.kafka.KafkaEventStream"
SENTRY_EVENTSTREAM_OPTIONS = {"producer_configuration": DEFAULT_KAFKA_OPTIONS}


#   -------------------------------------------------------------
#   TSDB / Snuba
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


SENTRY_TSDB = "sentry.tsdb.redissnuba.RedisSnubaTSDB"
SENTRY_SNUBA = "http://{{ args.services.snuba }}:1218"

SENTRY_SEARCH = "sentry.search.snuba.EventsDatasetSnubaSearchBackend"
SENTRY_SEARCH_OPTIONS = {}
SENTRY_TAGSTORE_OPTIONS = {}


#   -------------------------------------------------------------
#   Web server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


SENTRY_WEB_HOST = "0.0.0.0"
SENTRY_WEB_PORT = 9000
SENTRY_WEB_OPTIONS = {
    "http": "%s:%s" % (SENTRY_WEB_HOST, SENTRY_WEB_PORT),
    "protocol": "uwsgi",
    # This is needed in order to prevent https://github.com/getsentry/sentry/blob/c6f9660e37fcd9c1bbda8ff4af1dcfd0442f5155/src/sentry/services/http.py#L70
    "uwsgi-socket": None,
    "so-keepalive": True,
    # Keep this between 15s-75s as that's what Relay supports
    "http-keepalive": 15,
    "http-chunked-input": True,
    # the number of web workers
    "workers": 3,
    "threads": 4,
    "memory-report": False,
    # Some stuff so uwsgi will cycle workers sensibly
    "max-requests": 100000,
    "max-requests-delta": 500,
    "max-worker-lifetime": 86400,
    # Duplicate options from sentry default just so we don't get
    # bit by sentry changing a default value that we depend on.
    "thunder-lock": True,
    "log-x-forwarded-for": False,
    "buffer-size": 32768,
    "limit-post": 209715200,
    "disable-logging": True,
    "reload-on-rss": 600,
    "ignore-sigpipe": True,
    "ignore-write-errors": True,
    "disable-write-exception": True,
}


#   -------------------------------------------------------------
#   TLS
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")
USE_X_FORWARDED_HOST = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SOCIAL_AUTH_REDIRECT_IS_HTTPS = True


#   -------------------------------------------------------------
#   Mail
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


SENTRY_OPTIONS["mail.list-namespace"] = "{{ args.hostname }}"
SENTRY_OPTIONS["mail.from"] = "{{ args.email_from }}"


#   -------------------------------------------------------------
#   Integration - GitHub
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


if REALM == "nasqueron":
    secret = read_app_secret("github")
    for k, v in secret.items():
        if k == "id":
            v = int(v)
        SENTRY_OPTIONS["github-app." + k] = v


#   -------------------------------------------------------------
#   Features
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


SENTRY_FEATURES["projects:sample-events"] = False
SENTRY_FEATURES.update(
    {
        feature: True
        for feature in (
            "organizations:discover",
            "organizations:events",
            "organizations:global-views",
            "organizations:incidents",
            "organizations:integrations-issue-basic",
            "organizations:integrations-issue-sync",
            "organizations:invite-members",
            "organizations:metric-alert-builder-aggregate",
            "organizations:sso-basic",
            "organizations:sso-rippling",
            "organizations:sso-saml2",
            "organizations:performance-view",
            "organizations:advanced-search",
            "organizations:session-replay",
            "projects:custom-inbound-filters",
            "projects:data-forwarding",
            "projects:discard-groups",
            "projects:plugins",
            "projects:rate-limits",
            "projects:servicehooks",
        )
    }
)
