#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-01-18
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Ports to build manually
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ports:
  xaos:
    category: graphics
    name: xaos
    creates: /usr/local/bin/xaos
    options:
      set:
        - NLS
        - AALIB
      unset:
        - THREADS
        - GTK2
        - "X11"

  ffmpeg:
    category: multimedia
    name: ffmpeg
    creates: /usr/local/bin/ffmpeg
    options:
      set:
        - AOM
        - CACA
        - DAV1D
        - FONTCONFIG
        - FREETYPE
        - FREI0R
        - ICONV
        - LAME
        - MMX
        - OPENCV
        - OPTIMIZED_CFLAGS
        - OPUS
        - RTCPU
        - SSE
        - THEORA
        - V4L
        - VAAPI
        - VDPAU
        - VORBIS
        - VPX
        - "X264"
        - "X265"
        - XCB
        - XVID
        - GMP
        - GNUTLS
        - GPL3
        - NONFREE
      unset:
        - ALSA
        - AMR_NB
        - AMR_WB
        - ASS
        - BEIGNET
        - BS2B
        - CDIO
        - CELT
        - CODEC2
        - DC1394
        - DEBUG
        - DOCS
        - DRM
        - FDK_AAC
        - FLITE
        - FRIBIDI
        - GME
        - GSM
        - ILBC
        - JACK
        - KVAZAAR
        - LADSPA
        - LENSFUN
        - LIBBLURAY
        - LIBRSVG2
        - LIBXML2
        - LV2
        - MODPLUG
        - MYSOFA
        - OPENAL
        - OPENCL
        - OPENGL
        - OPENH264
        - OPENJPEG
        - OPENMPT
        - POCKETSPHINX
        - PULSEAUDIO
        - RAV1E
        - RUBBERBAND
        - SDL
        - SMB
        - SNAPPY
        - SNDIO
        - SOXR
        - SPEEX
        - SSH
        - SVTAV1
        - SVTHEVC
        - SVTVP9
        - TESSERACT
        - TWOLAME
        - VAPOURSYNTH
        - VIDSTAB
        - VMAF
        - VO_AMRWBENC
        - WAVPACK
        - WEBP
        - XVIDEO
        - ZIMG
        - ZMQ
        - ZVBI
        - GCRYPT
        - LIBRTMP
        - MBEDTLS
        - OPENSSL

  node:
    category: www
    name: node
    creates: /usr/local/bin/node
    options:
      set:
        - BUNDLED_SSL
        - NLS
      unset:
        - DOCS
        - DTRACE

  npm:
    category: www
    name: npm
    creates: /usr/local/bin/npm
