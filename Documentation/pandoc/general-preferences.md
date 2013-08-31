![](architecture.png "SOGo architecture")

To identify the level in which each parameter can be defined, we use the following abbreviations in the tables of this document :

----- -----------------------------------------------------------------
**S** Parameter exclusive to the system and not configurable per domain
**D** Parameter exclusive to a domain and not configurable per user
**U** Parameter configurable by the user
-----------------------------------------------------------------------

Remember that the hierarchy paradigm allows the default value of a parameter to be defined at a parent level.

## General Preferences ##

**S**  _WOWorkersCount_
:    The amount of instances of SOGo that will be spawned to handle multiple requests simultaneously.

     When started from the init script, that amount is overriden by the `$PREFORK` value in `/etc/sysconfig/sogo` or `/etc/default/sogo`.
     A value of 3 is a reasonable default for low usage.
     A value of 10 is generally sufficient for Setups with a few hundreds of users.
     The maximum value depends on the amount of available memory, CPU and IO bandwidth provided by your machine:
     a value set too high will actually decrease performances under high load.

     Defaults to 1 when unset.

 **S**  _WOPort_
:    The TCP port used by the SOGo daemon.

     Defaults to 20000 when unset.

**S**  *WOLogFile*
:    The file path where to log messages.

     Specify - to log to the console.

     Defaults to /var/log/sogo/sogo.log.

**S**  _WOPidFile_
:    The file path where the parent process id will be written.
     Defaults to /var/run/sogo/sogo.pid.

**S**  _WOWatchDogRequestTimeout_
:    This parameter specifies the number of minutes after which a busy child process will be killed by the parent process.

     Defaults to 10 (minutes).
     Do not set this too low as child processes replying to clients on a slow internet connection could be killed prematurely.

**S**  _SxVMemLimit_
:    Parameter used to set the maximum amount of memory (in megabytes) that a child can use.

     Reaching that value will force children processes to restart, in order to preserve system memory.

     Defaults to 384.

**S**  _SOGoMemcachedHost_
:    Parameter used to set the hostname and optionally the port of the memcached server.

     A path can also be used if the server must be reached via a Unix socket.

     Defaults to localhost.
     See memcached_servers_parse(3) for details on the syntax.

**S**  _SOGoCacheCleanupInterval_
:    Parameter used to set the expiration (in seconds) of each object in the cache.

     Defaults to 300.

**S**  _SOGoAuthenticationType_
:    Parameter used to define the way by which users will be authenticated.

     For C.A.S., specify `cas`.
     For SAML2, specify `saml2`.
     For anything else, leave that value empty.

**S**  _SOGoTrustProxyAuthentication_
:    Parameter used to set whether HTTP username should be trusted.

     Defaults to NO when unset.

**S**  _SOGoEncryptionKey_
:    Parameter used to define a key to encrypt the passwords of remote Web calendars when SOGoTrustProxyAuthentication is enabled.

**S**  _SOGoCASServiceURL_
:    When using C.A.S. authentication, this specifies the base url for reaching the C.A.S. service.

    This will be used by SOGo to deduce the proper login page as well as the other C.A.S. services that SOGo will use.

**S**  _SOGoCASLogoutEnabled_
:    Boolean value indicating whether the “Logout” link is enabled when using C.A.S. as authentication mechanism.

     The “Logout”link will end up calling SOGoCASServiceURL/logout to terminate the client's single sign-on C.A.S. session.

**S**  _SOGoAddressBookDAVAccessEnabled_
:    Parameter controlling WebDAV access to the Contacts collections.

     This can be used to deny access to these resources from Lightning for example.

     Defaults to YES when unset.

**S**  _SOGoCalendarDAVAccessEnabled_
:    Parameter controlling WebDAV access to the Calendar collections.

     This can be used to deny access to these resources from Lightning for example.

     Defaults to YES when unset.

**S**  _SOGoSAML2PrivateKeyLocation_
:    The location of the SSL private key file on the filesystem that is used by SOGo to sign and encrypt communications with the SAML2 identity provider.

     This file must be generated for each running SOGo service (rather than host).

**S**  _SOGoSAML2CertiticateLocation_
:    The location of the SSL certificate file.

     This file must be generated for each running SOGo service.

**S**  _SOGoSAML2IdpMetadataLocation_
:    The location of the metadata file that describes the services available on the SAML2 identify provider.

**S**  _SOGoSAML2IdpPublicKeyLocation_
:    The location of the SSL public key file on the filesystem that is used by SOGo to sign and encrypt communications with the SAML2 identity provider.

     This file should be part of the setup of your identity provider.

**S**  _SOGoSAML2IdpCertificateLocation_
:    The location of the SSL certificate file.

     This file should be part of the setup of your identity provider.

**S**  _SOGoSAML2LogoutEnabled_
:    Boolean value indicated whether the “Logout” link is enabled when using SAML2 as authentication mechanism.

**D**  _SOGoTimeZone_
:    Parameter used to set a default time zone for users.

     The default timezone is set to UTC.
     The Olson database is a standard database that takes all the time zones around the world into account and represents them along with their history.
     On GNU/Linux systems, time zone definition files are available under `/usr/share/zoneinfo`.
     Listing the available files will give you the name of the available time zones.
     This could be America/New_York, Europe/Berlin, Asia/Tokyo or Africa/Lubumbashi.


     In our example, we set the time zone to America/Montreal

**D**  _SOGoMailDomain_
:    Parameter used to set the default domain name used by SOGo.

     SOGo uses this parameter to build the list of valid email addresses for users.

     In our example, we set the default domain to acme.com

**D**  _SOGoAppointmentSendEMailNotifications_
:    Parameter used to set whether SOGo sends or not email notifications to meeting participants.

     Possible values are :
         - `YES` to send notifications
         - `NO`  to not send notifications

     Defaults to NO when unset.

**D**  _SOGoFoldersSendEMailNotifications_
:    Same as above, but the notifications are triggered on the creation of a calendar or an address book.

**D**  _SOGoACLsSendEMailNotifications_
:    Same as above, but the notifications are sent to the involved users of a calendar or address book's ACLs.

**D**  _SOGoCalendarDefaultRoles_
:    Parameter used to define the default roles when giving permissions to a user to access a calendar.

     Defaults roles are ignored for public accesses.
     Must be an array of up to five strings.
     Each string defining a role for an event category must begin with one of those values:

      - Public
      - Confidential
      - Private

     Each string must end with one of those values:

      - Viewer
      - DAndTViewer
      - Modifier
      - Responder

     The array can also contain one or many of the following strings:

      - ObjectCreator
      - ObjectEraser

     Example: `SOGoCalendarDefaultRoles = ("ObjectCreator", "PublicViewer");`

     Defaults to no role when unset.
     Recommended values is `SOGoCalendarDefaultRoles =  ("PublicViewer", "ConfidentialDAndTViewer")`

**D**  _SOGoContactsDefaultRoles_
:    Parameter used to define the default roles when giving permissions to a user to access an address book.

     *Defaults roles are ignored for public accesses.*
     
     Must be an array of one or many of the following strings:
     
      - ObjectViewer
      - ObjectEditor
      - ObjectCreator
      - ObjectEraser

     Example: `SOGoContactsDefaultRoles = ("ObjectEditor");`

     Defaults to no role when unset.

**D**  _SOGoSuperUsernames_
:    Array of usernames which are granted administrative privileges over all the users tables.

     For example, this could be used to post events in the users calendar without requiring the user to configure his/her ACLs.
     In this case you will need to specify those superuser's usernames like this :

         SOGoSuperUsernames = (<username1>[, <username2>, ...]);

     Empty by default.

**U**  _SOGoLanguage_
:    Parameter used to set the default language used in the Web interface for SOGo.

     Possible values are :

      - BrazilianPortuguese
      - Czech
      - Dutch
      - English
      - French
      - German
      - Hungarian
      - Italian
      - Russian
      - Spanish
      - Swedish
      - Welsh

**D**  _SOGoNotifyOnPersonalModifications_
:    Parameter used to set whether SOGo sends or not email receipts when someone changes his/her own calendar.

     Possible values are :

      - `YES` to send notifications
      - `NO`  to not send notifications

     Defaults to NO when unset.
     User can overwrite this from the calendar properties window.

**D**  _SOGoNotifyOnExternalModifications_
:    Parameter used to set whether SOGo sends or not email receipts when a modification is being done to his/her own calendar by someone else.

     Possible values are :
      - `YES` to send notifications
      - `NO`  to not send notifications

     Defaults to NO when unset.
     User can overwrite this from the calendar properties window.

**D**  _SOGoLDAPContactInfoAttribute_
:    Parameter used to specify an LDAP attribute that should be displayed when auto-completing user searches.

**D**  _SOGoiPhoneForceAllDayTransparency_
:    When set to YES, this will force all-day events sent over by iPhone OS based devices to be transparent.

     This means that the all-day events will not be considered during freebusy lookups.
     
     Defaults to NO when unset.

**S**  _SOGoEnablePublicAccess_
:    Parameter used to allow or not your users to share their calendars and address books publicly . (ie., *without* requiring authentication) 

     Possible values are :
      - `YES` to allow them
      - `NO`  to prevent them from doing so

     Defaults to NO when unset.

**S**  _SOGoPasswordChangeEnabled_
:    Parameter used to allow or not users to change their passwords from SOGo.

     Possible values are :
      - `YES` to allow them
      - `NO`  to prevent them from doing so

     Defaults to NO when unset.

     For this feature to work properly when authenticating against AD or Samba4, the LDAP connection must use SSL/TLS.
     Server side restrictions can also cause the password change to fail, in which case SOGo will only log a 'Constraint violation (0x13)' error.
     These restrictions include  Password too young, complexity constraints not satisfied, user cannot change password, etc...
     Also note that Samba has a minimum password age of 1 day by default.

**S**  _SOGoSupportedLanguages_
:    Parameter used to configure which languages are available from SOGo's Web interface.

     Available languages are specified as an array of string.
     
     The default value is :
     `( "Czech", "Welsh", "English", "Spanish", "French", "German", "Italian", "Hungarian", "Dutch", "BrazilianPortuguese", "Polish", "Russian", Ukrainian", "Swedish" )`

**D**  _SOGoHideSystemEMail_
:    Parameter used to control if SOGo should hide or not the system email address (UIDFieldName@SOGoMailDomain).

     This is currently limited to CalDAV (calendar-user-address-set).

     Defaults to NO when unset.

**D**  _SOGoSearchMinimumWordLength_
:    Parameter used to control the minimum length to be used for the search string (attendee completion, address book search, etc.) prior triggering the server-side search operation.

     Defaults to 2 when unset – which means a search operation will be triggered on the 3rd typed character.

**S**  _SOGoMaximumFailedLoginCount_
:    Parameter used to control the number of failed login attempts required during SOGoMaximumFailedLoginInterval seconds or more.

     If conditions are met, the account will be blocked for SOGoFailedLoginBlockInterval seconds since the first failed login attempt.
     
     Default value is 0, or disabled.

**S**  _SOGoMaximumFailedLoginInterval_
:    Number of seconds, defaults to 10.

**S**  _SOGoFailedLoginBlockInterval_
:    Number of seconds, defaults to 300 (or 5 minutes).

     Note that `SOGoCacheCleanupInterval` must be set to a value equal or higher than `SOGoFailedLoginBlockInterval`.

**S**  _SOGoMaximumMessageSubmissionCount_
:    Parameter used to control the number of email messages a user can send from SOGo's webmail interface, to SOGoMaximumRecipientCount, in SOGoMaximumSubmissionInterval seconds or more.

     If conditions are met or exceeded, the user won't be able to send mails for `SOGoMessageSubmissionBlockInterval` seconds.
     
     Default value is 0, or disabled.

**S**  _SOGoMaximumRecipientCount_
:    Maximum number of recipients.

     Default value is 0, or disabled.

**S**  _SOGoMaximumSubmissionInterval_
:    Number of seconds.

     Defaults to 30.

**S**  _SOGoMessageSubmissionBlockInterval_
:    Number of seconds.

     Default to 300 (or 5 minutes).
     Note that `SOGoCacheCleanupInterval` must be set to a value equal or higher than `SOGoFailedLoginBlockInterval`.

