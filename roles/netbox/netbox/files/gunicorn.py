#   -------------------------------------------------------------
#   Configure gunicorn
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


# The IP address (typically localhost) and port that the NetBox WSGI process should listen on
bind = "127.0.0.1:{{ app_port }}"

# Number of gunicorn workers to spawn. This should typically be 2n+1, where
# n is the number of CPU cores present.
workers = {{grains["num_cpus"] + 1}}

# Number of threads per worker process
threads = 3

# Timeout (in seconds) for a request to complete
timeout = 120

# The maximum number of requests a worker can handle before being respawned
max_requests = 5000
max_requests_jitter = 500
