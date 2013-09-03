% Installation and Configuration Guide
% Inverse Inc.

# About this guide #

This guide will walk you through the installation and configuration of the SOGo solution.
It also covers the installation and configuration of Funambol – the middleware used to synchronize mobile devices with SOGo.

The instructions are based on version $SOGO_VERSION$ of SOGo, and version 10.0 of Funambol.

The latest version of this guide is available at http://www.sogo.nu/downloads/documentation.html

# Introduction #

SOGo is a free and modern scalable groupware server.
It offers shared calendars, address books, and emails through your favourite Web browser and by using a native client such as Mozilla Thunderbird and Lightning.
SOGo is standard-compliant.
It supports CalDAV, CardDAV, GroupDAV, iMIP and iTIP and reuses existing IMAP, SMTP and database servers - making the solution easy to deploy and interoperable with many applications.

SOGo features :

 * Scalable architecture suitable for deployments from dozens to many thousands of users
 * Rich Web-based interface that shares the look and feel, the features and the data of Mozilla Thunderbird and Lightning
 * Improved integration with Mozilla Thunderbird and Lightning by using the SOGo Connector and the SOGo Integrator
 * Two-way synchronization support with any SyncML-capable devices (BlackBerry, Palm, Windows CE, etc.) by using the Funambol SOGo Connector

SOGo is developed by a community of developers located mainly in North America and Europe. More information can be found at http://sogo.nu/


## Architecture ##

The following diagram illustrate the SOGo architecture:\

![](architecture.png "SOGo architecture")

Standard protocols such as CalDAV, CardDAV, GroupDAV, HTTP, IMAP and SMTP are used to communicate with the SOGo platform or its sub-components.
Mobile devices supporting the SyncML standard use the Funambol middleware to synchronize information.

To install and configure the native Microsoft Outlook compatibility layer, please refer to the SOGo Native Microsoft Outlook Configuration Guide.

# System Requirements #

## Assumptions ##

SOGo reuses many components in an infrastructure.
Thus, it requires the following: 

* Database server (MySQL, PostgreSQL or Oracle)
* LDAP server (OpenLDAP, Novell eDirectory, Microsoft Active Directory and others) 
* SMTP server (Postfix, Sendmail and others)
* IMAP server (Courier, Cyrus IMAP Server, Dovecot and others)

In this guide, we assume that all those components are running on the same server (i.e., `localhost` or `127.0.0.1`) that SOGo will be installed on.

Good understanding of those underlying components and GNU/Linux is required to install SOGo.
If you miss some of those required components, please refer to the appropriate documentation and
proceed with the installation and configuration of these requirements before continuing with this guide.



--------------- ---------------------------------
Database server PostgreSQL 7.4 or later

LDAP server     OpenLDAP 2.3.x or later

SMTP server     Postfix 2.x

IMAP server     Cyrus IMAP Server 2.3.x or later
                Dovecot 2.x or later
-------------------------------------------------

:Software recommendations. (More recent versions of the software mentioned above can also be used.)


## Minimum hardware requirements ##

-------------- ------------------------------------------------------------------
Server         Evaluation and testing\
                - Intel, AMD, or PowerPC CPU 1 GHz\
                - 512 MB of RAM (without Funambol, 1 GB RAM otherwise)\
                - 1 GB of disk space\

               Production\
                Intel, AMD or PowerPC CPU 3 GHz\
                2048 MB of RAM\
                10 GB of disk space (excluding the mail store)\

Desktop        Intel, AMD, or PowerPC CPU 1.5 GHz
               1024x768 monitor resolution
               512 MB of RAM
               128 Kbps or higher network connection

               Microsoft Windows
               Microsoft Windows XP SP2 or later versions

               Apple Mac OS X
               Apple Mac OS X 10.2 or later

               Linux
               Your favourite GNU/Linux distribution

Mobile devices Any device supporting the CalDAV and CardDAV standards
               Apple iPhone / iPod / iPad using Apple iOS 3.0 or later
----------------------------------------------------------------------------------

## Operating System Requirements ##

The following 32-bit and 64-bit operating systems are currently supported by SOGo :

* Red Hat Enterprise Linux (RHEL) Server 5 and 6
* Community ENTerprise Operating System (CentOS) 5 and 6
* Debian GNU/Linux 6.0 (Squeeze) to 7.0 (Wheezy)
* Ubuntu 10.04 (Lucid) to 12.04 (Precise)

Make sure the required components are started automatically at boot time and that they are running before proceeding with the SOGo configuration.
Also make sure that you can install additional packages from your standard distribution.
For example, if you are using Red Hat Enterprise Linux 5, you have to be subscribed to the Red Hat Network before continuing with the SOGo software installation.

This document covers the installation of SOGo under RHEL 6.

For installation instructions on Debian and Ubuntu, please refer directly to the SOGo website at http://www.sogo.nu.
Under the downloads section, you will find links for installation steps for Debian and Ubuntu.

Note that once the SOGo packages are installed under Debian and Ubuntu, this guide can be followed in order to fully configure SOGo.

# Installation #

This section will guide you through the installation of SOGo together with its dependencies.
The steps described here apply to an RPM-based installation for a Red Hat or CentOS distribution.

## Software Downloads ##

SOGo can be installed using the yum utility.
To do so, first create the `/etc/yum.repos.d/inverse.repo` configuration file with the following content: 

    [SOGo]
    name=Inverse SOGo Repository
    baseurl=http://inverse.ca/downloads/SOGo/RHEL6/$basearch
    gpgcheck=0

Some of the softwares on which SOGo depends are available from the repository of RepoForge (previously known as RPMforge).
To add RepoForge to your packages sources, download and install the appropriate RPM package from http://packages.sw.be/rpmforge-release/.
Also make sure you enabled the “rpmforge-extras” repository.
For more information on using RepoForge, visit http://repoforge.org/use/


## Software Installation ##


Once the yum configuration file has been created, you are now ready to install SOGo and its dependencies. To do so, proceed with the following command :

    yum install sogo

This will install SOGo and its dependencies such as GNUstep, the SOPE packages and memcached.
Once the base packages are installed, you need to install the proper database connector suitable for your environment.
You need to install `sope49-gdl1-postgresql` for the PostgreSQL database system, `sope49-gdl1-mysql` for MySQL or `sope49-gdl1-oracle` for Oracle.

The installation command will thus look like this :

    yum install sope49-gdl1-postgresql

Once completed, SOGo will be fully installed on your server.
You are now ready to configure it.


# Configuration #

In this section, you'll learn how to configure SOGo to use your existing LDAP, SMTP and database servers.
As previously mentioned, we assume that those components run on the same server on which SOGo is being installed.
If this is not the case, please adjust the configuration parameters to reflect those changes.

## GNUstep Environment Overview ##

SOGo makes use of the GNUstep environment.
GNUstep is a free software implementation of the OpenStep specification which provides many facilities for building all types of server and desktop applications.
Among those facilities, there is a configuration API similar to the "Registry" paradigm in Microsoft Windows.
In OpenSTEP, GNUstep and MacOS X, these are called the "user defaults".

In SOGo, the user's applications settings are stored in `/etc/sogo/sogo.conf`.
You can use your favourite text editor to modify the file.
The sogo.conf file is a serialized property list.
This simple format encapsulates four basic data types:

  - arrays

    An array is a chain of values starting with "(" and ending with ")", where the values are separated with a ",".\ 
    For example: `bindFields = (mail, uid);`

  - dictionaries (or hash tables)

    A dictionary is a sequence of key and value pairs separated in their middle with a "=" sign.
    It starts with a "{" and ends with a corresponding "}".  
    Each value definition in a dictionary ends with a semicolon.\
    For example:
        
        dict = {
                 array = (value1, value2);
                 string = "stringValue";
                 bool = YES;
               }
        

  - strings

    Quoting strings is not mandatory, but doing so will avoid you many problems.\
    Example: `string = "value";`

  - numbers

    Numbers are represented as-is, except for booleans which can take the unquoted values `YES` and `NO`.

The file generally follows a C-style indentation for clarity but this indentation is not required, only recommended.
It also supports C-style comments, that is either long blocks enclosed within `/* */` or simple comments starting with `//` and continuing to the end of the current line.

## Preferences Hierarchy ##

SOGo supports domain names segregation, meaning that you can separate multiple groups of users within one installation of SOGo.
A user associated to a domain is limited to access only the users data from the same domain.
Consequently, the configuration parameters of SOGo are defined on three levels:
 
\Oldincludegraphics[height=6.59cm]{preferences.png}

Each level inherits the preferences of the parent level.
Therefore, domain preferences define the defaults values of the user preferences, and the system preferences define the default values of all domains preferences.
Both system and domains preferences are defined in the `/etc/sogo/sogo.conf`, while the users preferences are configurable by the user and stored in SOGo's database.

