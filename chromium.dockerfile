# Pull base image.
FROM linuxmintd/mint20-amd64
#FROM linuxmintd/lmde4-i386


# Make sure APT operations are non-interactive
ENV DEBIAN_FRONTEND noninteractive

# Add basic tools
RUN apt-get update && apt-get --yes install wget gnupg locales unzip libfile-fcntllock-perl equivs software-properties-common

# Set locale
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

###################################
# Set up repositories
###################################

# Update APT cache.
RUN apt-get update

###################################
# Apply updates
###################################

RUN apt-get dist-upgrade --yes

###################################
# Install stuff
###################################

RUN apt-get --yes install build-essential devscripts fakeroot quilt dh-make automake libdistro-info-perl less nano python3
