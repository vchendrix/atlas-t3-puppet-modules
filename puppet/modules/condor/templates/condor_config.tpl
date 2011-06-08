######################################################################
##
##  condor_config
##
##  This is the global configuration file for condor.  Any settings
##  made here may potentially be overridden in the local configuration
##  file.  KEEP THAT IN MIND!  To double-check that a variable is
##  getting set from the configuration file that you expect, use
##  condor_config_val -v <variable name>
##
##  The file is divided into four main parts:
##  Part 1:  Settings you MUST customize 
##  Part 2:  Settings you may want to customize
##  Part 3:  Settings that control the policy of when condor will
##           start and stop jobs on your machines
##  Part 4:  Settings you should probably leave alone (unless you
##  know what you're doing)
##
##  Please read the INSTALL file (or the Install chapter in the
##  Condor Administrator's Manual) for detailed explanations of the 
##  various settings in here and possible ways to configure your
##  pool. 
##
##  Unless otherwise specified, settings that are commented out show
##  the defaults that are used if you don't define a value.  Settings
##  that are defined here MUST BE DEFINED since they have no default
##  value.
##
##  Unless otherwise indicated, all settings which specify a time are
##  defined in seconds.
##
######################################################################

######################################################################
######################################################################
##
##  ######                                     #
##  #     #    ##    #####    #####           ##
##  #     #   #  #   #    #     #            # #
##  ######   #    #  #    #     #              #
##  #        ######  #####      #              #
##  #        #    #  #   #      #              #
##  #        #    #  #    #     #            #####
##
##  Part 1:  Settings you must customize:
######################################################################
######################################################################

##  What machine is your central manager?
CONDOR_HOST	= <%= ipaddress %>

##--------------------------------------------------------------------
##  Pathnames:
##--------------------------------------------------------------------
##  Where have you installed the bin, sbin and lib condor directories?   
RELEASE_DIR		= /usr

##  Where is the local condor directory for each host?  
##  This is where the local config file(s), logs and
##  spool/execute directories are located
LOCAL_DIR		= /var
#LOCAL_DIR		= $(RELEASE_DIR)/hosts/$(HOSTNAME)

##  Where is the machine-specific local config file for each host?
LOCAL_CONFIG_FILE	= /etc/condor/condor_config.local
#LOCAL_CONFIG_FILE	= $(RELEASE_DIR)/etc/$(HOSTNAME).local

## If the local config file is not present, is it an error?
## WARNING: This is a potential security issue. 
## If not specificed, the default is True
#REQUIRE_LOCAL_CONFIG_FILE = TRUE

##--------------------------------------------------------------------
##  Mail parameters:
##--------------------------------------------------------------------
##  When something goes wrong with condor at your site, who should get
##  the email?
CONDOR_ADMIN		= root@$(FULL_HOSTNAME)

##  Full path to a mail delivery program that understands that "-s"
##  means you want to specify a subject:
MAIL			= /bin/mail

##--------------------------------------------------------------------
##  Network domain parameters:
##--------------------------------------------------------------------
##  Internet domain of machines sharing a common UID space.  If your
##  machines don't share a common UID space, set it to 
##  UID_DOMAIN = $(FULL_HOSTNAME)
##  to specify that each machine has its own UID space.
#UID_DOMAIN		= <%= filesystemdomain %>
UID_DOMAIN		=  $(FULL_HOSTNAME)

##  Internet domain of machines sharing a common file system.
##  If your machines don't use a network file system, set it to
##  FILESYSTEM_DOMAIN = $(FULL_HOSTNAME)
##  to specify that each machine has its own file system. 
#FILESYSTEM_DOMAIN	= <%= filesystemdomain %>
FILESYSTEM_DOMAIN	= $(FULL_HOSTNAME)


##  This macro is used to specify a short description of your pool. 
##  It should be about 20 characters long. For example, the name of 
##  the UW-Madison Computer Science Condor Pool is ``UW-Madison CS''.
COLLECTOR_NAME 		= My Pool

######################################################################
######################################################################
##  
##  ######                                   #####
##  #     #    ##    #####    #####         #     #
##  #     #   #  #   #    #     #                 #
##  ######   #    #  #    #     #            #####
##  #        ######  #####      #           #
##  #        #    #  #   #      #           #
##  #        #    #  #    #     #           #######
##  
##  Part 2:  Settings you may want to customize: 
##  (it is generally safe to leave these untouched) 
######################################################################
######################################################################

##
##  The user/group ID <uid>.<gid> of the "Condor" user. 
##  (this can also be specified in the environment)
##  Note: the CONDOR_IDS setting is ignored on Win32 platforms
#CONDOR_IDS=x.x

##--------------------------------------------------------------------
##  Flocking: Submitting jobs to more than one pool
##--------------------------------------------------------------------
##  Flocking allows you to run your jobs in other pools, or lets
##  others run jobs in your pool.
## 
##  To let others flock to you, define FLOCK_FROM.
## 
##  To flock to others, define FLOCK_TO.

##  FLOCK_FROM defines the machines where you would like to grant
##  people access to your pool via flocking. (i.e. you are granting
##  access to these machines to join your pool).
FLOCK_FROM = 
##  An example of this is:
#FLOCK_FROM = somehost.friendly.domain, anotherhost.friendly.domain

##  FLOCK_TO defines the central managers of the pools that you want
##  to flock to. (i.e. you are specifying the machines that you
##  want your jobs to be negotiated at -- thereby specifying the
##  pools they will run in.)
FLOCK_TO = 
##  An example of this is:
#FLOCK_TO = central_manager.friendly.domain, condor.cs.wisc.edu

##  FLOCK_COLLECTOR_HOSTS should almost always be the same as
##  FLOCK_NEGOTIATOR_HOSTS (as shown below).  The only reason it would be
##  different is if the collector and negotiator in the pool that you are
##  flocking too are running on different machines (not recommended).
##  The collectors must be specified in the same corresponding order as
##  the FLOCK_NEGOTIATOR_HOSTS list.
FLOCK_NEGOTIATOR_HOSTS = $(FLOCK_TO)
FLOCK_COLLECTOR_HOSTS = $(FLOCK_TO)
## An example of having the negotiator and the collector on different
## machines is:
#FLOCK_NEGOTIATOR_HOSTS = condor.cs.wisc.edu, condor-negotiator.friendly.domain
#FLOCK_COLLECTOR_HOSTS =  condor.cs.wisc.edu, condor-collector.friendly.domain

##--------------------------------------------------------------------
##  Host/IP access levels
##--------------------------------------------------------------------
##  Please see the administrator's manual for details on these
##  settings, what they're for, and how to use them.

##  What machines have administrative rights for your pool?  This
##  defaults to your central manager.  You should set it to the
##  machine(s) where whoever is the condor administrator(s) works
##  (assuming you trust all the users who log into that/those
##  machine(s), since this is machine-wide access you're granting).
ALLOW_ADMINISTRATOR = $(CONDOR_HOST)

##  If there are no machines that should have administrative access 
##  to your pool (for example, there's no machine where only trusted
##  users have accounts), you can uncomment this setting.
##  Unfortunately, this will mean that administering your pool will 
##  be more difficult.
#DENY_ADMINISTRATOR = *

##  What machines should have "owner" access to your machines, meaning
##  they can issue commands that a machine owner should be able to
##  issue to their own machine (like condor_vacate).  This defaults to
##  machines with administrator access, and the local machine.  This
##  is probably what you want.
ALLOW_OWNER = $(FULL_HOSTNAME), $(ALLOW_ADMINISTRATOR)

##  Read access.  Machines listed as allow (and/or not listed as deny)
##  can view the status of your pool, but cannot join your pool 
##  or run jobs.
##  NOTE: By default, without these entries customized, you
##  are granting read access to the whole world.  You may want to
##  restrict that to hosts in your domain.  If possible, please also
##  grant read access to "*.cs.wisc.edu", so the Condor developers
##  will be able to view the status of your pool and more easily help
##  you install, configure or debug your Condor installation.
##  It is important to have this defined.
ALLOW_READ = * 
#ALLOW_READ = *.your.domain, *.cs.wisc.edu
#DENY_READ = *.bad.subnet, bad-machine.your.domain, 144.77.88.*

##  Write access.  Machines listed here can join your pool, submit
##  jobs, etc.  Note: Any machine which has WRITE access must
##  also be granted READ access.  Granting WRITE access below does
##  not also automatically grant READ access; you must change
##  ALLOW_READ above as well.
##
##  You must set this to something else before Condor will run.
##  This most simple option is:
##    ALLOW_WRITE = *
##  but note that this will allow anyone to submit jobs or add
##  machines to your pool and is a serious security risk.

ALLOW_WRITE = *
#ALLOW_WRITE = *.your.domain, your-friend's-machine.other.domain
#DENY_WRITE = bad-machine.your.domain

##  Are you upgrading to a new version of Condor and confused about
##  why the above ALLOW_WRITE setting is causing Condor to refuse to
##  start up?  If you are upgrading from a configuration that uses
##  HOSTALLOW/HOSTDENY instead of ALLOW/DENY we recommend that you
##  convert all uses of the former to the latter.  The syntax of the
##  authorization settings is identical.  They both support
##  unauthenticated IP-based authorization as well as authenticated
##  user-based authorization.  To avoid confusion, the use of
##  HOSTALLOW/HOSTDENY is discouraged.  Support for it may be removed
##  in the future.

##  Negotiator access.  Machines listed here are trusted central
##  managers.  You should normally not have to change this.
ALLOW_NEGOTIATOR = $(CONDOR_HOST), <%= condor_allow_negotiator_extra %>
##  Now, with flocking we need to let the SCHEDD trust the other 
##  negotiators we are flocking with as well.  You should normally 
##  not have to change this either.
ALLOW_NEGOTIATOR_SCHEDD = $(CONDOR_HOST), $(FLOCK_NEGOTIATOR_HOSTS), <%= condor_allow_negotiator_extra %>

##  Config access.  Machines listed here can use the condor_config_val
##  tool to modify all daemon configurations.  This level of host-wide
##  access should only be granted with extreme caution.  By default,
##  config access is denied from all hosts.
#ALLOW_CONFIG = trusted-host.your.domain

##  Flocking Configs.  These are the real things that Condor looks at,
##  but we set them from the FLOCK_FROM/TO macros above.  It is safe
##  to leave these unchanged.
ALLOW_WRITE_COLLECTOR = $(ALLOW_WRITE), $(FLOCK_FROM)
ALLOW_WRITE_STARTD    = $(ALLOW_WRITE), $(FLOCK_FROM)
ALLOW_READ_COLLECTOR  = $(ALLOW_READ), $(FLOCK_FROM)
ALLOW_READ_STARTD     = $(ALLOW_READ), $(FLOCK_FROM)


##--------------------------------------------------------------------
##  Security parameters for setting configuration values remotely:
##--------------------------------------------------------------------
##  These parameters define the list of attributes that can be set
##  remotely with condor_config_val for the security access levels
##  defined above (for example, WRITE, ADMINISTRATOR, CONFIG, etc).
##  Please see the administrator's manual for futher details on these
##  settings, what they're for, and how to use them.  There are no
##  default values for any of these settings.  If they are not
##  defined, no attributes can be set with condor_config_val.

## Do you want to allow condor_config_val -rset to work at all?
## This feature is disabled by default, so to enable, you must
## uncomment the following setting and change the value to "True". 
## Note: changing this requires a restart not just a reconfig.
#ENABLE_RUNTIME_CONFIG = False

## Do you want to allow condor_config_val -set to work at all?
## This feature is disabled by default, so to enable, you must
## uncomment the following setting and change the value to "True". 
## Note: changing this requires a restart not just a reconfig.
#ENABLE_PERSISTENT_CONFIG = False

## Directory where daemons should write persistent config files (used
## to support condor_config_val -set).  This directory should *ONLY*
## be writable by root (or the user the Condor daemons are running as
## if non-root).  There is no default, administrators must define this.
## Note: changing this requires a restart not just a reconfig.
#PERSISTENT_CONFIG_DIR = /full/path/to/root-only/local/directory

##  Attributes that can be set by hosts with "CONFIG" permission (as
##  defined with ALLOW_CONFIG and DENY_CONFIG above).
##  The commented-out value here was the default behavior of Condor
##  prior to version 6.3.3.  If you don't need this behavior, you
##  should leave this commented out.
#SETTABLE_ATTRS_CONFIG = *

##  Attributes that can be set by hosts with "ADMINISTRATOR"
##  permission (as defined above)
#SETTABLE_ATTRS_ADMINISTRATOR = *_DEBUG, MAX_*_LOG

##  Attributes that can be set by hosts with "OWNER" permission (as
##  defined above) NOTE: any Condor job running on a given host will
##  have OWNER permission on that host by default.  If you grant this
##  kind of access, Condor jobs will be able to modify any attributes
##  you list below on the machine where they are running.  This has
##  obvious security implications, so only grant this kind of
##  permission for custom attributes that you define for your own use
##  at your pool (custom attributes about your machines that are
##  published with the STARTD_ATTRS setting, for example).
#SETTABLE_ATTRS_OWNER = your_custom_attribute, another_custom_attr

##  You can also define daemon-specific versions of each of these
##  settings.  For example, to define settings that can only be
##  changed in the condor_startd's configuration by hosts with OWNER
##  permission, you would use:
#STARTD_SETTABLE_ATTRS_OWNER = your_custom_attribute_name

##--------------------------------------------------------------------
##  Password Authentication
##--------------------------------------------------------------------
## For Unix machines, the path and file name of the file containing 
## the pool password for password authentication. 
#SEC_PASSWORD_FILE = $(LOCAL_DIR)/lib/condor/pool_password

##--------------------------------------------------------------------
##  Network filesystem parameters:
##--------------------------------------------------------------------
##  Do you want to use NFS for file access instead of remote system
##  calls?
#USE_NFS		= False

##  Do you want to use AFS for file access instead of remote system
##  calls?
#USE_AFS		= False

##--------------------------------------------------------------------
##  Checkpoint server:
##--------------------------------------------------------------------
##  Do you want to use a checkpoint server if one is available?  If a
##  checkpoint server isn't available or USE_CKPT_SERVER is set to
##  False, checkpoints will be written to the local SPOOL directory on
##  the submission machine.
#USE_CKPT_SERVER	= True

##  What's the hostname of this machine's nearest checkpoint server?
#CKPT_SERVER_HOST	= checkpoint-server-hostname.your.domain

##  Do you want the starter on the execute machine to choose the
##  checkpoint server?  If False, the CKPT_SERVER_HOST set on
##  the submit machine is used.  Otherwise, the CKPT_SERVER_HOST set
##  on the execute machine is used.  The default is true.
#STARTER_CHOOSES_CKPT_SERVER = True

##--------------------------------------------------------------------
##  Miscellaneous:
##--------------------------------------------------------------------
##  Try to save this much swap space by not starting new shadows.  
##  Specified in megabytes.
#RESERVED_SWAP		= 0

##  What's the maximum number of jobs you want a single submit machine
##  to spawn shadows for?  The default is a function of $(DETECTED_MEMORY)
##  and a guess at the number of ephemeral ports available.

## Example 1:
#MAX_JOBS_RUNNING	= 10000

## Example 2:
## This is more complicated, but it produces the same limit as the default.
## First define some expressions to use in our calculation.
## Assume we can use up to 80% of memory and estimate shadow private data
## size of 800k.
#MAX_SHADOWS_MEM	= ceiling($(DETECTED_MEMORY)*0.8*1024/800)
## Assume we can use ~21,000 ephemeral ports (avg ~2.1 per shadow).
## Under Linux, the range is set in /proc/sys/net/ipv4/ip_local_port_range.
#MAX_SHADOWS_PORTS	= 10000
## Under windows, things are much less scalable, currently.
## Note that this can probably be safely increased a bit under 64-bit windows.
#MAX_SHADOWS_OPSYS	= ifThenElse(regexp("WIN.*","$(OPSYS)"),200,100000)
## Now build up the expression for MAX_JOBS_RUNNING.  This is complicated
## due to lack of a min() function.
#MAX_JOBS_RUNNING	= $(MAX_SHADOWS_MEM)
#MAX_JOBS_RUNNING	= \
#  ifThenElse( $(MAX_SHADOWS_PORTS) < $(MAX_JOBS_RUNNING), \
#              $(MAX_SHADOWS_PORTS), \
#              $(MAX_JOBS_RUNNING) )
#MAX_JOBS_RUNNING	= \
#  ifThenElse( $(MAX_SHADOWS_OPSYS) < $(MAX_JOBS_RUNNING), \
#              $(MAX_SHADOWS_OPSYS), \
#              $(MAX_JOBS_RUNNING) )


##  Maximum number of simultaneous downloads of output files from
##  execute machines to the submit machine (limit applied per schedd).
##  The value 0 means unlimited.
#MAX_CONCURRENT_DOWNLOADS = 10

##  Maximum number of simultaneous uploads of input files from the
##  submit machine to execute machines (limit applied per schedd).
##  The value 0 means unlimited.
#MAX_CONCURRENT_UPLOADS = 10

##  Condor needs to create a few lock files to synchronize access to
##  various log files.  Because of problems we've had with network
##  filesystems and file locking over the years, we HIGHLY recommend
##  that you put these lock files on a local partition on each
##  machine.  If you don't have your LOCAL_DIR on a local partition,
##  be sure to change this entry.  Whatever user (or group) condor is
##  running as needs to have write access to this directory.  If
##  you're not running as root, this is whatever user you started up
##  the condor_master as.  If you are running as root, and there's a
##  condor account, it's probably condor.  Otherwise, it's whatever
##  you've set in the CONDOR_IDS environment variable.  See the Admin
##  manual for details on this.
LOCK		= $(LOCAL_DIR)/lock/condor

##  If you don't use a fully qualified name in your /etc/hosts file
##  (or NIS, etc.) for either your official hostname or as an alias,
##  Condor wouldn't normally be able to use fully qualified names in
##  places that it'd like to.  You can set this parameter to the
##  domain you'd like appended to your hostname, if changing your host
##  information isn't a good option.  This parameter must be set in
##  the global config file (not the LOCAL_CONFIG_FILE from above). 
#DEFAULT_DOMAIN_NAME = your.domain.name

##  If you don't have DNS set up, Condor will normally fail in many
##  places because it can't resolve hostnames to IP addresses and
##  vice-versa. If you enable this option, Condor will use
##  pseudo-hostnames constructed from a machine's IP address and the
##  DEFAULT_DOMAIN_NAME. Both NO_DNS and DEFAULT_DOMAIN must be set in
##  your top-level config file for this mode of operation to work
##  properly.
#NO_DNS = True

##  Condor can be told whether or not you want the Condor daemons to
##  create a core file if something really bad happens.  This just
##  sets the resource limit for the size of a core file.  By default,
##  we don't do anything, and leave in place whatever limit was in
##  effect when you started the Condor daemons.  If this parameter is
##  set and "True", we increase the limit to as large as it gets.  If
##  it's set to "False", we set the limit at 0 (which means that no
##  core files are even created).  Core files greatly help the Condor
##  developers debug any problems you might be having.
#CREATE_CORE_FILES	= True

##  When Condor daemons detect a fatal internal exception, they
##  normally log an error message and exit.  If you have turned on
##  CREATE_CORE_FILES, in some cases you may also want to turn on
##  ABORT_ON_EXCEPTION so that core files are generated when an
##  exception occurs.  Set the following to True if that is what you
##  want.
#ABORT_ON_EXCEPTION = False

##  Condor Glidein downloads binaries from a remote server for the
##  machines into which you're gliding. This saves you from manually
##  downloading and installing binaries for every architecture you
##  might want to glidein to. The default server is one maintained at
##  The University of Wisconsin. If you don't want to use the UW
##  server, you can set up your own and change the following to
##  point to it, instead.
GLIDEIN_SERVER_URLS = \
  http://www.cs.wisc.edu/condor/glidein/binaries

## List the sites you want to GlideIn to on the GLIDEIN_SITES. For example, 
## if you'd like to GlideIn to some Alliance GiB resources, 
## uncomment the line below.
## Make sure that $(GLIDEIN_SITES) is included in ALLOW_READ and
## ALLOW_WRITE, or else your GlideIns won't be able to join your pool.
## This is _NOT_ done for you by default, because it is an even better
## idea to use a strong security method (such as GSI) rather than
## host-based security for authorizing glideins.
#GLIDEIN_SITES = *.ncsa.uiuc.edu, *.cs.wisc.edu, *.mcs.anl.gov 
#GLIDEIN_SITES = 

##  If your site needs to use UID_DOMAIN settings (defined above) that
##  are not real Internet domains that match the hostnames, you can
##  tell Condor to trust whatever UID_DOMAIN a submit machine gives to
##  the execute machine and just make sure the two strings match.  The
##  default for this setting is False, since it is more secure this
##  way.
TRUST_UID_DOMAIN = True

## If you would like to be informed in near real-time via condor_q when
## a vanilla/standard/java job is in a suspension state, set this attribute to
## TRUE. However, this real-time update of the condor_schedd by the shadows 
## could cause performance issues if there are thousands of concurrently
## running vanilla/standard/java jobs under a single condor_schedd and they
## are allowed to suspend and resume.
#REAL_TIME_JOB_SUSPEND_UPDATES = False

## A standard universe job can perform arbitrary shell calls via the
## libc 'system()' function. This function call is routed back to the shadow
## which performs the actual system() invocation in the initialdir of the
## running program and as the user who submitted the job. However, since the
## user job can request ARBITRARY shell commands to be run by the shadow, this
## is a generally unsafe practice. This should only be made available if it is
## actually needed. If this attribute is not defined, then it is the same as
## it being defined to False. Set it to True to allow the shadow to execute
## arbitrary shell code from the user job.
#SHADOW_ALLOW_UNSAFE_REMOTE_EXEC = False

## KEEP_OUTPUT_SANDBOX is an optional feature to tell Condor-G to not
## remove the job spool when the job leaves the queue.  To use, just
## set to TRUE.  Since you will be operating Condor-G in this manner,
## you may want to put leave_in_queue = false in your job submit
## description files, to tell Condor-G to simply remove the job from
## the queue immediately when the job completes (since the output files
## will stick around no matter what).
#KEEP_OUTPUT_SANDBOX = False

## This setting tells the negotiator to ignore user priorities.  This
## avoids problems where jobs from different users won't run when using
## condor_advertise instead of a full-blown startd (some of the user
## priority system in Condor relies on information from the startd --
## we will remove this reliance when we support the user priority
## system for grid sites in the negotiator; for now, this setting will
## just disable it).
#NEGOTIATOR_IGNORE_USER_PRIORITIES = False

## These are the directories used to locate classad plug-in functions
#CLASSAD_SCRIPT_DIRECTORY =
#CLASSAD_LIB_PATH =

## This setting tells Condor whether to delegate or copy GSI X509
## credentials when sending them over the wire between daemons.
## Delegation can take up to a second, which is very slow when
## submitting a large number of jobs. Copying exposes the credential
## to third parties if Condor isn't set to encrypt communications.
## By default, Condor will delegate rather than copy.
#DELEGATE_JOB_GSI_CREDENTIALS = True

## This setting controls whether Condor delegates a full or limited
## X509 credential for jobs. Currently, this only affects grid-type
## gt2 grid universe jobs. The default is False.
#DELEGATE_FULL_JOB_GSI_CREDENTIALS = False

## This setting controls the default behaviour for the spooling of files
## into, or out of, the Condor system by such tools as condor_submit
## and condor_transfer_data. Here is the list of valid settings for this
## parameter and what they mean:
##
##   stm_use_schedd_only
##      Ask the condor_schedd to solely store/retreive the sandbox
##
##   stm_use_transferd
##      Ask the condor_schedd for a location of a condor_transferd, then
##      store/retreive the sandbox from the transferd itself.
##
## The allowed values are case insensitive.
## The default of this parameter if not specified is: stm_use_schedd_only
#SANDBOX_TRANSFER_METHOD = stm_use_schedd_only

##--------------------------------------------------------------------
##  Settings that control the daemon's debugging output:
##--------------------------------------------------------------------

##
## The flags given in ALL_DEBUG are shared between all daemons.
##

ALL_DEBUG               =

MAX_COLLECTOR_LOG	= 1000000
COLLECTOR_DEBUG		=

MAX_KBDD_LOG		= 1000000
KBDD_DEBUG		=

MAX_NEGOTIATOR_LOG	= 1000000
NEGOTIATOR_DEBUG	= D_MATCH
MAX_NEGOTIATOR_MATCH_LOG = 1000000

MAX_SCHEDD_LOG		= 1000000
SCHEDD_DEBUG		= D_PID

MAX_SHADOW_LOG		= 1000000
SHADOW_DEBUG		=

MAX_STARTD_LOG		= 1000000
STARTD_DEBUG		= 

MAX_STARTER_LOG		= 1000000

MAX_MASTER_LOG		= 1000000
MASTER_DEBUG		= 
##  When the master starts up, should it truncate it's log file?
#TRUNC_MASTER_LOG_ON_OPEN        = False

MAX_JOB_ROUTER_LOG      = 1000000
JOB_ROUTER_DEBUG        =

MAX_ROOSTER_LOG         = 1000000
ROOSTER_DEBUG           =

MAX_HDFS_LOG            = 1000000
HDFS_DEBUG              =

# High Availability Logs
MAX_HAD_LOG		= 1000000
HAD_DEBUG		=
MAX_REPLICATION_LOG	= 1000000
REPLICATION_DEBUG	=
MAX_TRANSFERER_LOG	= 1000000
TRANSFERER_DEBUG	=


## The daemons touch their log file periodically, even when they have
## nothing to write. When a daemon starts up, it prints the last time
## the log file was modified. This lets you estimate when a previous
## instance of a daemon stopped running. This paramete controls how often
## the daemons touch the file (in seconds).
#TOUCH_LOG_INTERVAL = 60

######################################################################
######################################################################
##  
##  ######                                   #####
##  #     #    ##    #####    #####         #     #
##  #     #   #  #   #    #     #                 #
##  ######   #    #  #    #     #            #####
##  #        ######  #####      #                 #
##  #        #    #  #   #      #           #     #
##  #        #    #  #    #     #            #####
##  
##  Part 3:  Settings control the policy for running, stopping, and
##  periodically checkpointing condor jobs:
######################################################################
######################################################################

##  This section contains macros are here to help write legible
##  expressions:
MINUTE		= 60
HOUR		= (60 * $(MINUTE))
StateTimer	= (CurrentTime - EnteredCurrentState)
ActivityTimer	= (CurrentTime - EnteredCurrentActivity)
ActivationTimer = ifThenElse(JobStart =!= UNDEFINED, (CurrentTime - JobStart), 0)
LastCkpt	= (CurrentTime - LastPeriodicCheckpoint)

##  The JobUniverse attribute is just an int.  These macros can be
##  used to specify the universe in a human-readable way:
STANDARD	= 1
VANILLA		= 5
MPI		= 8
VM		= 13
IsMPI           = (TARGET.JobUniverse == $(MPI))
IsVanilla       = (TARGET.JobUniverse == $(VANILLA))
IsStandard      = (TARGET.JobUniverse == $(STANDARD))
IsVM            = (TARGET.JobUniverse == $(VM))

NonCondorLoadAvg	= (LoadAvg - CondorLoadAvg)
BackgroundLoad		= 0.3
HighLoad		= 0.5
StartIdleTime		= 15 * $(MINUTE)
ContinueIdleTime	=  5 * $(MINUTE)
MaxSuspendTime		= 10 * $(MINUTE)
MaxVacateTime		= 10 * $(MINUTE)

KeyboardBusy		= (KeyboardIdle < $(MINUTE))
ConsoleBusy		= (ConsoleIdle  < $(MINUTE))
CPUIdle			= ($(NonCondorLoadAvg) <= $(BackgroundLoad))
CPUBusy			= ($(NonCondorLoadAvg) >= $(HighLoad))
KeyboardNotBusy		= ($(KeyboardBusy) == False)

BigJob		= (TARGET.ImageSize >= (50 * 1024))
MediumJob	= (TARGET.ImageSize >= (15 * 1024) && TARGET.ImageSize < (50 * 1024))
SmallJob	= (TARGET.ImageSize <  (15 * 1024))

JustCPU			= ($(CPUBusy) && ($(KeyboardBusy) == False))
MachineBusy		= ($(CPUBusy) || $(KeyboardBusy))

##  The RANK expression controls which jobs this machine prefers to
##  run over others.  Some examples from the manual include:
##    RANK = TARGET.ImageSize
##    RANK = (Owner == "coltrane") + (Owner == "tyner") \
##                  + ((Owner == "garrison") * 10) + (Owner == "jones")
##  By default, RANK is always 0, meaning that all jobs have an equal
##  ranking.
#RANK			= 0


#####################################################################
##  This where you choose the configuration that you would like to
##  use.  It has no defaults so it must be defined.  We start this
##  file off with the UWCS_* policy.
######################################################################

##  Also here is what is referred to as the TESTINGMODE_*, which is
##  a quick hardwired way to test Condor with a simple no-preemption policy.
##  Replace UWCS_* with TESTINGMODE_* if you wish to do testing mode.
##  For example:
##  WANT_SUSPEND 		= $(UWCS_WANT_SUSPEND)
##  becomes
##  WANT_SUSPEND 		= $(TESTINGMODE_WANT_SUSPEND)

# When should we only consider SUSPEND instead of PREEMPT?
WANT_SUSPEND 		= $(UWCS_WANT_SUSPEND)

# When should we preempt gracefully instead of hard-killing?
WANT_VACATE		= $(UWCS_WANT_VACATE)

##  When is this machine willing to start a job? 
START			= $(UWCS_START)

##  When should a local universe job be allowed to start?
#START_LOCAL_UNIVERSE	= TotalLocalJobsRunning < 200

##  When should a scheduler universe job be allowed to start?
#START_SCHEDULER_UNIVERSE	= TotalSchedulerJobsRunning < 200

##  When to suspend a job?
SUSPEND			= $(UWCS_SUSPEND)

##  When to resume a suspended job?
CONTINUE		= $(UWCS_CONTINUE)

##  When to nicely stop a job?
##  (as opposed to killing it instantaneously)
PREEMPT			= $(UWCS_PREEMPT)

##  When to instantaneously kill a preempting job
##  (e.g. if a job is in the pre-empting stage for too long)
KILL			= $(UWCS_KILL)

PERIODIC_CHECKPOINT	= $(UWCS_PERIODIC_CHECKPOINT)
PREEMPTION_REQUIREMENTS	= $(UWCS_PREEMPTION_REQUIREMENTS)
PREEMPTION_RANK		= $(UWCS_PREEMPTION_RANK)
NEGOTIATOR_PRE_JOB_RANK = $(UWCS_NEGOTIATOR_PRE_JOB_RANK)
NEGOTIATOR_POST_JOB_RANK = $(UWCS_NEGOTIATOR_POST_JOB_RANK)
MaxJobRetirementTime    = $(UWCS_MaxJobRetirementTime)
CLAIM_WORKLIFE          = $(UWCS_CLAIM_WORKLIFE)

#####################################################################
## This is the UWisc - CS Department Configuration.
#####################################################################

# When should we only consider SUSPEND instead of PREEMPT?
# Only when SUSPEND is True and one of the following is also true:
#   - the job is small
#   - the keyboard is idle
#   - it is a vanilla universe job
UWCS_WANT_SUSPEND  = ( $(SmallJob) || $(KeyboardNotBusy) || $(IsVanilla) ) && \
                     ( $(SUSPEND) )

# When should we preempt gracefully instead of hard-killing?
UWCS_WANT_VACATE   = ( $(ActivationTimer) > 10 * $(MINUTE) || $(IsVanilla) )

# Only start jobs if:
# 1) the keyboard has been idle long enough, AND
# 2) the load average is low enough OR the machine is currently
#    running a Condor job 
# (NOTE: Condor will only run 1 job at a time on a given resource.
# The reasons Condor might consider running a different job while
# already running one are machine Rank (defined above), and user
# priorities.)
UWCS_START	= ( (KeyboardIdle > $(StartIdleTime)) \
                    && ( $(CPUIdle) || \
                         (State != "Unclaimed" && State != "Owner")) )

# Suspend jobs if:
# 1) the keyboard has been touched, OR
# 2a) The cpu has been busy for more than 2 minutes, AND
# 2b) the job has been running for more than 90 seconds
UWCS_SUSPEND = ( $(KeyboardBusy) || \
                 ( (CpuBusyTime > 2 * $(MINUTE)) \
                   && $(ActivationTimer) > 90 ) )

# Continue jobs if:
# 1) the cpu is idle, AND 
# 2) we've been suspended more than 10 seconds, AND
# 3) the keyboard hasn't been touched in a while
UWCS_CONTINUE = ( $(CPUIdle) && ($(ActivityTimer) > 10) \
                  && (KeyboardIdle > $(ContinueIdleTime)) )

# Preempt jobs if:
# 1) The job is suspended and has been suspended longer than we want
# 2) OR, we don't want to suspend this job, but the conditions to
#    suspend jobs have been met (someone is using the machine)
UWCS_PREEMPT = ( ((Activity == "Suspended") && \
                  ($(ActivityTimer) > $(MaxSuspendTime))) \
		 || (SUSPEND && (WANT_SUSPEND == False)) )

# Maximum time (in seconds) to wait for a job to finish before kicking
# it off (due to PREEMPT, a higher priority claim, or the startd
# gracefully shutting down).  This is computed from the time the job
# was started, minus any suspension time.  Once the retirement time runs
# out, the usual preemption process will take place.  The job may
# self-limit the retirement time to _less_ than what is given here.
# By default, nice user jobs and standard universe jobs set their
# MaxJobRetirementTime to 0, so they will not wait in retirement.

UWCS_MaxJobRetirementTime = 0

##  If you completely disable preemption of claims to machines, you
##  should consider limiting the timespan over which new jobs will be
##  accepted on the same claim.  See the manual section on disabling
##  preemption for a comprehensive discussion.  Since this example
##  configuration does not disable preemption of claims, we leave
##  CLAIM_WORKLIFE undefined (infinite).
#UWCS_CLAIM_WORKLIFE = 1200

# Kill jobs if they have taken too long to vacate gracefully
UWCS_KILL = $(ActivityTimer) > $(MaxVacateTime) 

##  Only define vanilla versions of these if you want to make them
##  different from the above settings.
#SUSPEND_VANILLA  = ( $(KeyboardBusy) || \
#       ((CpuBusyTime > 2 * $(MINUTE)) && $(ActivationTimer) > 90) )
#CONTINUE_VANILLA = ( $(CPUIdle) && ($(ActivityTimer) > 10) \
#                     && (KeyboardIdle > $(ContinueIdleTime)) )
#PREEMPT_VANILLA  = ( ((Activity == "Suspended") && \
#                     ($(ActivityTimer) > $(MaxSuspendTime))) \
#                     || (SUSPEND_VANILLA && (WANT_SUSPEND == False)) )
#KILL_VANILLA    = $(ActivityTimer) > $(MaxVacateTime)

##  Checkpoint every 3 hours on average, with a +-30 minute random
##  factor to avoid having many jobs hit the checkpoint server at
##  the same time.
UWCS_PERIODIC_CHECKPOINT	= $(LastCkpt) > (3 * $(HOUR) + \
                                  $RANDOM_INTEGER(-30,30,1) * $(MINUTE) )

##  You might want to checkpoint a little less often.  A good
##  example of this is below.  For jobs smaller than 60 megabytes, we
##  periodic checkpoint every 6 hours.  For larger jobs, we only
##  checkpoint every 12 hours.
#UWCS_PERIODIC_CHECKPOINT	= \
#          ( (TARGET.ImageSize < 60000) && \
#            ($(LastCkpt) > (6  * $(HOUR) + $RANDOM_INTEGER(-30,30,1))) ) || \ 
#          (  $(LastCkpt) > (12 * $(HOUR) + $RANDOM_INTEGER(-30,30,1)) )

##  The rank expressions used by the negotiator are configured below.
##  This is the order in which ranks are applied by the negotiator:
##    1. NEGOTIATOR_PRE_JOB_RANK
##    2. rank in job ClassAd
##    3. NEGOTIATOR_POST_JOB_RANK
##    4. cause of preemption (0=user priority,1=startd rank,2=no preemption)
##    5. PREEMPTION_RANK

##  The NEGOTIATOR_PRE_JOB_RANK expression overrides all other ranks
##  that are used to pick a match from the set of possibilities.
##  The following expression matches jobs to unclaimed resources
##  whenever possible, regardless of the job-supplied rank.
UWCS_NEGOTIATOR_PRE_JOB_RANK = RemoteOwner =?= UNDEFINED

##  The NEGOTIATOR_POST_JOB_RANK expression chooses between
##  resources that are equally preferred by the job.
##  The following example expression steers jobs toward
##  faster machines and tends to fill a cluster of multi-processors
##  breadth-first instead of depth-first.  It also prefers online
##  machines over offline (hibernating) ones.  In this example,
##  the expression is chosen to have no effect when preemption
##  would take place, allowing control to pass on to
##  PREEMPTION_RANK.
UWCS_NEGOTIATOR_POST_JOB_RANK = \
 (RemoteOwner =?= UNDEFINED) * (KFlops - SlotID - 1.0e10*(Offline=?=True))

##  The negotiator will not preempt a job running on a given machine
##  unless the PREEMPTION_REQUIREMENTS expression evaluates to true
##  and the owner of the idle job has a better priority than the owner
##  of the running job.  This expression defaults to true.
UWCS_PREEMPTION_REQUIREMENTS = ( $(StateTimer) > (1 * $(HOUR)) && \
	RemoteUserPrio > SubmitterUserPrio * 1.2 ) || (MY.NiceUser == True)

##  The PREEMPTION_RANK expression is used in a case where preemption
##  is the only option and all other negotiation ranks are equal.  For
##  example, if the job has no preference, it is usually preferable to
##  preempt a job with a small ImageSize instead of a job with a large
##  ImageSize.  The default is to rank all preemptable matches the
##  same.  However, the negotiator will always prefer to match the job
##  with an idle machine over a preemptable machine, if all other
##  negotiation ranks are equal.
UWCS_PREEMPTION_RANK = (RemoteUserPrio * 1000000) - TARGET.ImageSize


#####################################################################
##  This is a Configuration that will cause your Condor jobs to
##  always run.  This is intended for testing only.
######################################################################

##  This mode will cause your jobs to start on a machine an will let
##  them run to completion.  Condor will ignore all of what is going
##  on in the machine (load average, keyboard activity, etc.)

TESTINGMODE_WANT_SUSPEND	= False
TESTINGMODE_WANT_VACATE		= False
TESTINGMODE_START			= True
TESTINGMODE_SUSPEND			= False
TESTINGMODE_CONTINUE		= True
TESTINGMODE_PREEMPT			= False
TESTINGMODE_KILL			= False
TESTINGMODE_PERIODIC_CHECKPOINT	= False
TESTINGMODE_PREEMPTION_REQUIREMENTS = False
TESTINGMODE_PREEMPTION_RANK = 0

# Prevent machine claims from being reused indefinitely, since
# preemption of claims is disabled in the TESTINGMODE configuration.
TESTINGMODE_CLAIM_WORKLIFE = 1200


######################################################################
######################################################################
##  
##  ######                                  #
##  #     #    ##    #####    #####         #    #
##  #     #   #  #   #    #     #           #    #
##  ######   #    #  #    #     #           #    #
##  #        ######  #####      #           #######
##  #        #    #  #   #      #                #
##  #        #    #  #    #     #                #
##  
##  Part 4:  Settings you should probably leave alone:
##  (unless you know what you're doing)
######################################################################
######################################################################

######################################################################
##  Daemon-wide settings:
######################################################################

##  Pathnames
RUN		= $(LOCAL_DIR)/run/condor
LOG		= $(LOCAL_DIR)/log/condor
SPOOL		= $(LOCAL_DIR)/lib/condor/spool
EXECUTE		= $(LOCAL_DIR)/lib/condor/execute
BIN		= $(RELEASE_DIR)/bin
LIB = $(RELEASE_DIR)/lib64/condor
INCLUDE		= $(RELEASE_DIR)/include/condor
SBIN		= $(RELEASE_DIR)/sbin
LIBEXEC		= $(RELEASE_DIR)/libexec/condor
SHARE		= $(RELEASE_DIR)/share/condor 

## If you leave HISTORY undefined (comment it out), no history file
## will be created. 
HISTORY		= $(SPOOL)/history

##  Log files
COLLECTOR_LOG	= $(LOG)/CollectorLog
KBDD_LOG	= $(LOG)/KbdLog
MASTER_LOG	= $(LOG)/MasterLog
NEGOTIATOR_LOG	= $(LOG)/NegotiatorLog
NEGOTIATOR_MATCH_LOG = $(LOG)/MatchLog
SCHEDD_LOG	= $(LOG)/SchedLog
SHADOW_LOG	= $(LOG)/ShadowLog
STARTD_LOG	= $(LOG)/StartLog
STARTER_LOG	= $(LOG)/StarterLog
JOB_ROUTER_LOG  = $(LOG)/JobRouterLog
ROOSTER_LOG     = $(LOG)/RoosterLog
# High Availability Logs
HAD_LOG		= $(LOG)/HADLog
REPLICATION_LOG	= $(LOG)/ReplicationLog
TRANSFERER_LOG	= $(LOG)/TransfererLog
HDFS_LOG	= $(LOG)/HDFSLog

##  Lock files
SHADOW_LOCK	= $(LOCK)/ShadowLock

## This setting controls how often any lock files currently in use have their
## timestamp updated. Updating the timestamp prevents administrative programs 
## like 'tmpwatch' from deleting long lived lock files. The parameter is
## an integer in seconds with a minimum of 60 seconds. The default if not
## specified is 28800 seconds, or 8 hours.
## This attribute only takes effect on restart of the daemons or at the next
## update time.
# LOCK_FILE_UPDATE_INTERVAL = 28800

##  This setting primarily allows you to change the port that the
##  collector is listening on.  By default, the collector uses port
##  9618, but you can set the port with a ":port", such as:
##  COLLECTOR_HOST = $(CONDOR_HOST):1234
COLLECTOR_HOST  = $(CONDOR_HOST)

## The NEGOTIATOR_HOST parameter has been deprecated.  The port where
## the negotiator is listening is now dynamically allocated and the IP
## and port are now obtained from the collector, just like all the
## other daemons.  However, if your pool contains any machines that
## are running version 6.7.3 or earlier, you can uncomment this
## setting to go back to the old fixed-port (9614) for the negotiator.
#NEGOTIATOR_HOST = $(CONDOR_HOST)

##  How long are you willing to let daemons try their graceful
##  shutdown methods before they do a hard shutdown? (30 minutes)
#SHUTDOWN_GRACEFUL_TIMEOUT	= 1800

##  How much disk space would you like reserved from Condor?  In
##  places where Condor is computing the free disk space on various
##  partitions, it subtracts the amount it really finds by this
##  many megabytes.  (If undefined, defaults to 0).
RESERVED_DISK		= 5

##  If your machine is running AFS and the AFS cache lives on the same
##  partition as the other Condor directories, and you want Condor to
##  reserve the space that your AFS cache is configured to use, set
##  this to true.
#RESERVE_AFS_CACHE	= False

##  By default, if a user does not specify "notify_user" in the submit
##  description file, any email Condor sends about that job will go to
##  "username@UID_DOMAIN".  If your machines all share a common UID
##  domain (so that you would set UID_DOMAIN to be the same across all
##  machines in your pool), *BUT* email to user@UID_DOMAIN is *NOT*
##  the right place for Condor to send email for your site, you can
##  define the default domain to use for email.  A common example
##  would be to set EMAIL_DOMAIN to the fully qualified hostname of
##  each machine in your pool, so users submitting jobs from a
##  specific machine would get email sent to user@machine.your.domain,
##  instead of user@your.domain.  In general, you should leave this
##  setting commented out unless two things are true: 1) UID_DOMAIN is
##  set to your domain, not $(FULL_HOSTNAME), and 2) email to
##  user@UID_DOMAIN won't work.
#EMAIL_DOMAIN = $(FULL_HOSTNAME)

##  Should Condor daemons create a UDP command socket (for incomming
##  UDP-based commands) in addition to the TCP command socket?  By
##  default, classified ad updates sent to the collector use UDP, in
##  addition to some keep alive messages and other non-essential
##  communication.  However, in certain situations, it might be
##  desirable to disable the UDP command port (for example, to reduce
##  the number of ports represented by a GCB broker, etc).  If not
##  defined, the UDP command socket is enabled by default, and to
##  modify this, you must restart your Condor daemons. Also, this
##  setting must be defined machine-wide.  For example, setting
##  "STARTD.WANT_UDP_COMMAND_SOCKET = False" while the global setting
##  is "True" will still result in the startd creating a UDP socket.
#WANT_UDP_COMMAND_SOCKET = True

##  If your site needs to use TCP updates to the collector, instead of
##  UDP, you can enable this feature.  HOWEVER, WE DO NOT RECOMMEND
##  THIS FOR MOST SITES!  In general, the only sites that might want
##  this feature are pools made up of machines connected via a
##  wide-area network where UDP packets are frequently or always
##  dropped.  If you enable this feature, you *MUST* turn on the
##  COLLECTOR_SOCKET_CACHE_SIZE setting at your collector, and each
##  entry in the socket cache uses another file descriptor.  If not
##  defined, this feature is disabled by default.
#UPDATE_COLLECTOR_WITH_TCP = True

## HIGHPORT and LOWPORT let you set the range of ports that Condor
## will use. This may be useful if you are behind a firewall. By
## default, Condor uses port 9618 for the collector, 9614 for the
## negotiator, and system-assigned (apparently random) ports for
## everything else. HIGHPORT and LOWPORT only affect these
## system-assigned ports, but will restrict them to the range you
## specify here. If you want to change the well-known ports for the
## collector or negotiator, see COLLECTOR_HOST or NEGOTIATOR_HOST.
## Note that both LOWPORT and HIGHPORT must be at least 1024 if you
## are not starting your daemons as root.  You may also specify
## different port ranges for incoming and outgoing connections by
## using IN_HIGHPORT/IN_LOWPORT and OUT_HIGHPORT/OUT_LOWPORT.
#HIGHPORT = 9700 
#LOWPORT = 9600

##  If a daemon doens't respond for too long, do you want go generate
##  a core file?  This bascially controls the type of the signal
##  sent to the child process, and mostly affects the Condor Master
#NOT_RESPONDING_WANT_CORE	= False


######################################################################
##  Daemon-specific settings:
######################################################################

##--------------------------------------------------------------------
##  condor_master
##--------------------------------------------------------------------
##  Daemons you want the master to keep running for you:
DAEMON_LIST			= MASTER, STARTD, SCHEDD

##  Which daemons use the Condor DaemonCore library (i.e., not the
##  checkpoint server or custom user daemons)?
#DC_DAEMON_LIST = \
#MASTER, STARTD, SCHEDD, KBDD, COLLECTOR, NEGOTIATOR, EVENTD, \
#VIEW_SERVER, CONDOR_VIEW, VIEW_COLLECTOR, HAWKEYE, CREDD, HAD, \
#DBMSD, QUILL, JOB_ROUTER, ROOSTER, LEASEMANAGER, HDFS


##  Where are the binaries for these daemons?
MASTER				= $(SBIN)/condor_master
STARTD				= $(SBIN)/condor_startd
SCHEDD				= $(SBIN)/condor_schedd
KBDD				= $(SBIN)/condor_kbdd
NEGOTIATOR			= $(SBIN)/condor_negotiator
COLLECTOR			= $(SBIN)/condor_collector
STARTER_LOCAL			= $(SBIN)/condor_starter
JOB_ROUTER                      = $(LIBEXEC)/condor_job_router
ROOSTER                         = $(LIBEXEC)/condor_rooster
HDFS				= $(LIBEXEC)/condor_hdfs

##  When the master starts up, it can place it's address (IP and port)
##  into a file.  This way, tools running on the local machine don't
##  need to query the central manager to find the master.  This
##  feature can be turned off by commenting out this setting.
MASTER_ADDRESS_FILE = $(LOG)/.master_address

##  Where should the master find the condor_preen binary? If you don't
##  want preen to run at all, just comment out this setting.
PREEN				= $(SBIN)/condor_preen

##  How do you want preen to behave?  The "-m" means you want email
##  about files preen finds that it thinks it should remove.  The "-r"
##  means you want preen to actually remove these files.  If you don't
##  want either of those things to happen, just remove the appropriate
##  one from this setting.
PREEN_ARGS			= -m -r

##  How often should the master start up condor_preen? (once a day)
#PREEN_INTERVAL			= 86400

##  If a daemon dies an unnatural death, do you want email about it?
#PUBLISH_OBITUARIES		= True

##  If you're getting obituaries, how many lines of the end of that
##  daemon's log file do you want included in the obituary?
#OBITUARY_LOG_LENGTH		= 20

##  Should the master run?
#START_MASTER			= True

##  Should the master start up the daemons you want it to?
#START_DAEMONS			= True

##  How often do you want the master to send an update to the central
##  manager? 
#MASTER_UPDATE_INTERVAL		= 300

##  How often do you want the master to check the timestamps of the
##  daemons it's running?  If any daemons have been modified, the
##  master restarts them.
#MASTER_CHECK_NEW_EXEC_INTERVAL	= 300

##  Once you notice new binaries, how long should you wait before you
##  try to execute them?
#MASTER_NEW_BINARY_DELAY	= 120

##  What's the maximum amount of time you're willing to give the
##  daemons to quickly shutdown before you just kill them outright?
#SHUTDOWN_FAST_TIMEOUT		= 120

######
##  Exponential backoff settings:
######
##  When a daemon keeps crashing, we use "exponential backoff" so we
##  wait longer and longer before restarting it.  This is the base of
##  the exponent used to determine how long to wait before starting
##  the daemon again:
#MASTER_BACKOFF_FACTOR		= 2.0

##  What's the maximum amount of time you want the master to wait
##  between attempts to start a given daemon?  (With 2.0 as the
##  MASTER_BACKOFF_FACTOR, you'd hit 1 hour in 12 restarts...)
#MASTER_BACKOFF_CEILING		= 3600

##  How long should a daemon run without crashing before we consider
##  it "recovered".  Once a daemon has recovered, we reset the number
##  of restarts so the exponential backoff stuff goes back to normal. 
#MASTER_RECOVER_FACTOR		= 300


##--------------------------------------------------------------------
##  condor_startd
##--------------------------------------------------------------------
##  Where are the various condor_starter binaries installed?
STARTER_LIST = STARTER, STARTER_STANDARD
STARTER			= $(SBIN)/condor_starter
STARTER_STANDARD	= $(SBIN)/condor_starter.std
STARTER_LOCAL		= $(SBIN)/condor_starter

##  When the startd starts up, it can place it's address (IP and port)
##  into a file.  This way, tools running on the local machine don't
##  need to query the central manager to find the startd.  This
##  feature can be turned off by commenting out this setting.
STARTD_ADDRESS_FILE	= $(LOG)/.startd_address

##  When a machine is claimed, how often should we poll the state of
##  the machine to see if we need to evict/suspend the job, etc?
#POLLING_INTERVAL        = 5

##  How often should the startd send updates to the central manager? 
#UPDATE_INTERVAL         = 300

##  How long is the startd willing to stay in the "matched" state?
#MATCH_TIMEOUT		= 300

##  How long is the startd willing to stay in the preempting/killing
##  state before it just kills the starter directly?
#KILLING_TIMEOUT	= 30

##  When a machine unclaimed, when should it run benchmarks?
##  LastBenchmark is initialized to 0, so this expression says as soon
##  as we're unclaimed, run the benchmarks.  Thereafter, if we're
##  unclaimed and it's been at least 4 hours since we ran the last
##  benchmarks, run them again.  The startd keeps a weighted average
##  of the benchmark results to provide more accurate values.
##  Note, if you don't want any benchmarks run at all, either comment
##  RunBenchmarks out, or set it to "False".
BenchmarkTimer = (CurrentTime - LastBenchmark)
RunBenchmarks : (LastBenchmark == 0 ) || ($(BenchmarkTimer) >= (4 * $(HOUR)))
#RunBenchmarks : False

##  Normally, when the startd is computing the idle time of all the
##  users of the machine (both local and remote), it checks the utmp
##  file to find all the currently active ttys, and only checks access
##  time of the devices associated with active logins.  Unfortunately,
##  on some systems, utmp is unreliable, and the startd might miss
##  keyboard activity by doing this.  So, if your utmp is unreliable,
##  set this setting to True and the startd will check the access time
##  on all tty and pty devices.
#STARTD_HAS_BAD_UTMP = False

##  This entry allows the startd to monitor console (keyboard and
##  mouse) activity by checking the access times on special files in
##  /dev.  Activity on these files shows up as "ConsoleIdle" time in
##  the startd's ClassAd.  Just give a comma-separated list of the
##  names of devices you want considered the console, without the
##  "/dev/" portion of the pathname.
CONSOLE_DEVICES	= mouse, console


##  The STARTD_ATTRS (and legacy STARTD_EXPRS) entry allows you to
##  have the startd advertise arbitrary attributes from the config
##  file in its ClassAd.  Give the comma-separated list of entries
##  from the config file you want in the startd ClassAd.
##  NOTE: because of the different syntax of the config file and
##  ClassAds, you might have to do a little extra work to get a given
##  entry into the ClassAd.  In particular, ClassAds require double
##  quotes (") around your strings.  Numeric values can go in
##  directly, as can boolean expressions.  For example, if you wanted
##  the startd to advertise its list of console devices, when it's
##  configured to run benchmarks, and how often it sends updates to
##  the central manager, you'd have to define the following helper
##  macro:
#MY_CONSOLE_DEVICES = "$(CONSOLE_DEVICES)"
##  Note: this must come before you define STARTD_ATTRS because macros
##  must be defined before you use them in other macros or
##  expressions.
##  Then, you'd set the STARTD_ATTRS setting to this:
#STARTD_ATTRS = MY_CONSOLE_DEVICES, RunBenchmarks, UPDATE_INTERVAL
##
##  STARTD_ATTRS can also be defined on a per-slot basis.  The startd
##  builds the list of attributes to advertise by combining the lists
##  in this order: STARTD_ATTRS, SLOTx_STARTD_ATTRS.  In the below
##  example, the startd ad for slot1 will have the value for
##  favorite_color, favorite_season, and favorite_movie, and slot2
##  will have favorite_color, favorite_season, and favorite_song.
##
#STARTD_ATTRS = favorite_color, favorite_season
#SLOT1_STARTD_ATTRS = favorite_movie
#SLOT2_STARTD_ATTRS = favorite_song
##
##  Attributes in the STARTD_ATTRS list can also be on a per-slot basis.
##  For example, the following configuration:
##
#favorite_color = "blue"
#favorite_season = "spring"
#SLOT2_favorite_color = "green"
#SLOT3_favorite_season = "summer"
#STARTD_ATTRS = favorite_color, favorite_season
##
##  will result in the following attributes in the slot classified
##  ads:
##
## slot1 - favorite_color = "blue"; favorite_season = "spring"
## slot2 - favorite_color = "green"; favorite_season = "spring"
## slot3 - favorite_color = "blue"; favorite_season = "summer"
##
##  Finally, the recommended default value for this setting, is to
##  publish the COLLECTOR_HOST setting as a string.  This can be
##  useful using the "$$(COLLECTOR_HOST)" syntax in the submit file
##  for jobs to know (for example, via their environment) what pool
##  they're running in.
COLLECTOR_HOST_STRING = "$(COLLECTOR_HOST)"
STARTD_ATTRS = COLLECTOR_HOST_STRING

##  When the startd is claimed by a remote user, it can also advertise
##  arbitrary attributes from the ClassAd of the job its working on.
##  Just list the attribute names you want advertised.  
##  Note: since this is already a ClassAd, you don't have to do
##  anything funny with strings, etc.  This feature can be turned off
##  by commenting out this setting (there is no default).
STARTD_JOB_EXPRS = ImageSize, ExecutableSize, JobUniverse, NiceUser

##  If you want to "lie" to Condor about how many CPUs your machine
##  has, you can use this setting to override Condor's automatic
##  computation.  If you modify this, you must restart the startd for
##  the change to take effect (a simple condor_reconfig will not do).
##  Please read the section on "condor_startd Configuration File
##  Macros" in the Condor Administrators Manual for a further
##  discussion of this setting.  Its use is not recommended.  This
##  must be an integer ("N" isn't a valid setting, that's just used to
##  represent the default).
#NUM_CPUS = N

##  If you never want Condor to detect more the "N" CPUs, uncomment this
##  line out. You must restart the startd for this setting to take 
##  effect. If set to 0 or a negative number, it is ignored. 
##  By default, it is ignored. Otherwise, it must be a positive  
##  integer ("N" isn't a valid setting, that's just used to
##  represent the default).
#MAX_NUM_CPUS = N

##  Normally, Condor will automatically detect the amount of physical
##  memory available on your machine.  Define MEMORY to tell Condor
##  how much physical memory (in MB) your machine has, overriding the
##  value Condor computes automatically.  For example:
#MEMORY = 128

##  How much memory would you like reserved from Condor?  By default,
##  Condor considers all the physical memory of your machine as
##  available to be used by Condor jobs.  If RESERVED_MEMORY is
##  defined, Condor subtracts it from the amount of memory it
##  advertises as available.
#RESERVED_MEMORY = 0

######
##  SMP startd settings
##
##  By default, Condor will evenly divide the resources in an SMP
##  machine (such as RAM, swap space and disk space) among all the
##  CPUs, and advertise each CPU as its own slot with an even share of
##  the system resources.  If you want something other than this,
##  there are a few options available to you.  Please read the section
##  on "Configuring The Startd for SMP Machines" in the Condor
##  Administrator's Manual for full details.  The various settings are
##  only briefly listed and described here.
######

##  The maximum number of different slot types.
#MAX_SLOT_TYPES = 10

##  Use this setting to define your own slot types.  This
##  allows you to divide system resources unevenly among your CPUs.
##  You must use a different setting for each different type you
##  define.  The "<N>" in the name of the macro listed below must be
##  an integer from 1 to MAX_SLOT_TYPES (defined above),
##  and you use this number to refer to your type.  There are many
##  different formats these settings can take, so be sure to refer to
##  the section on "Configuring The Startd for SMP Machines" in the
##  Condor Administrator's Manual for full details.  In particular,
##  read the section titled "Defining Slot Types" to help
##  understand this setting.  If you modify any of these settings, you
##  must restart the condor_start for the change to take effect.
#SLOT_TYPE_<N> = 1/4
#SLOT_TYPE_<N> = cpus=1, ram=25%, swap=1/4, disk=1/4
#  For example:
#SLOT_TYPE_1 = 1/8
#SLOT_TYPE_2 = 1/4

##  If you define your own slot types, you must specify how
##  many slots of each type you wish to advertise.  You do
##  this with the setting below, replacing the "<N>" with the
##  corresponding integer you used to define the type above.  You can
##  change the number of a given type being advertised at run-time,
##  with a simple condor_reconfig.  
#NUM_SLOTS_TYPE_<N> = M
#  For example:
#NUM_SLOTS_TYPE_1 = 6
#NUM_SLOTS_TYPE_2 = 1

##  The number of evenly-divided slots you want Condor to
##  report to your pool (if less than the total number of CPUs).  This
##  setting is only considered if the "type" settings described above
##  are not in use.  By default, all CPUs are reported.  This setting
##  must be an integer ("N" isn't a valid setting, that's just used to
##  represent the default).
#NUM_SLOTS = N

##  How many of the slots the startd is representing should
##  be "connected" to the console (in other words, notice when there's
##  console activity)?  This defaults to all slots (N in a
##  machine with N CPUs).  This must be an integer ("N" isn't a valid
##  setting, that's just used to represent the default).
#SLOTS_CONNECTED_TO_CONSOLE = N

##  How many of the slots the startd is representing should
##  be "connected" to the keyboard (for remote tty activity, as well
##  as console activity).  Defaults to 1.
#SLOTS_CONNECTED_TO_KEYBOARD = 1

##  If there are slots that aren't connected to the
##  keyboard or the console (see the above two settings), the
##  corresponding idle time reported will be the time since the startd
##  was spawned, plus the value of this parameter.  It defaults to 20
##  minutes.  We do this because, if the slot is configured
##  not to care about keyboard activity, we want it to be available to
##  Condor jobs as soon as the startd starts up, instead of having to
##  wait for 15 minutes or more (which is the default time a machine
##  must be idle before Condor will start a job).  If you don't want
##  this boost, just set the value to 0.  If you change your START
##  expression to require more than 15 minutes before a job starts,
##  but you still want jobs to start right away on some of your SMP
##  nodes, just increase this parameter.
#DISCONNECTED_KEYBOARD_IDLE_BOOST = 1200

######
##  Settings for computing optional resource availability statistics:
######
##  If STARTD_COMPUTE_AVAIL_STATS = True, the startd will compute
##  statistics about resource availability to be included in the
##  classad(s) sent to the collector describing the resource(s) the
##  startd manages.  The following attributes will always be included
##  in the resource classad(s) if STARTD_COMPUTE_AVAIL_STATS = True:
##    AvailTime = What proportion of the time (between 0.0 and 1.0)
##      has this resource been in a state other than "Owner"?
##    LastAvailInterval = What was the duration (in seconds) of the
##      last period between "Owner" states?
##  The following attributes will also be included if the resource is
##  not in the "Owner" state:
##    AvailSince = At what time did the resource last leave the
##      "Owner" state?  Measured in the number of seconds since the
##      epoch (00:00:00 UTC, Jan 1, 1970).
##    AvailTimeEstimate = Based on past history, this is an estimate
##      of how long the current period between "Owner" states will
##      last.
#STARTD_COMPUTE_AVAIL_STATS = False

##  If STARTD_COMPUTE_AVAIL_STATS = True, STARTD_AVAIL_CONFIDENCE sets
##  the confidence level of the AvailTimeEstimate.  By default, the
##  estimate is based on the 80th percentile of past values.
#STARTD_AVAIL_CONFIDENCE = 0.8

##  STARTD_MAX_AVAIL_PERIOD_SAMPLES limits the number of samples of
##  past available intervals stored by the startd to limit memory and
##  disk consumption.  Each sample requires 4 bytes of memory and
##  approximately 10 bytes of disk space.
#STARTD_MAX_AVAIL_PERIOD_SAMPLES = 100

##	CKPT_PROBE is the location of a program which computes aspects of the
##	CheckpointPlatform classad attribute. By default the location of this
##	executable will be here: $(LIBEXEC)/condor_ckpt_probe
CKPT_PROBE = $(LIBEXEC)/condor_ckpt_probe

##--------------------------------------------------------------------
##  condor_schedd
##--------------------------------------------------------------------
##  Where are the various shadow binaries installed?
SHADOW_LIST = SHADOW, SHADOW_STANDARD
SHADOW			= $(SBIN)/condor_shadow
SHADOW_STANDARD		= $(SBIN)/condor_shadow.std

##  When the schedd starts up, it can place it's address (IP and port)
##  into a file.  This way, tools running on the local machine don't
##  need to query the central manager to find the schedd.  This
##  feature can be turned off by commenting out this setting.
SCHEDD_ADDRESS_FILE	= $(SPOOL)/.schedd_address

##  Additionally, a daemon may store its ClassAd on the local filesystem
##  as well as sending it to the collector. This way, tools that need
##  information about a daemon do not have to contact the central manager
##  to get information about a daemon on the same machine.
##  This feature is necessary for Quill to work.
SCHEDD_DAEMON_AD_FILE = $(SPOOL)/.schedd_classad

##  How often should the schedd send an update to the central manager?
#SCHEDD_INTERVAL	= 300 

##  How long should the schedd wait between spawning each shadow?
#JOB_START_DELAY	= 2

##  How many concurrent sub-processes should the schedd spawn to handle
##  queries?  (Unix only)
#SCHEDD_QUERY_WORKERS   = 3

##  How often should the schedd send a keep alive message to any
##  startds it has claimed?  (5 minutes)
#ALIVE_INTERVAL		= 300

##  This setting controls the maximum number of times that a
##  condor_shadow processes can have a fatal error (exception) before
##  the condor_schedd will simply relinquish the match associated with
##  the dying shadow.
#MAX_SHADOW_EXCEPTIONS	= 5

##  Estimated virtual memory size of each condor_shadow process. 
##  Specified in kilobytes.
# SHADOW_SIZE_ESTIMATE	= 800

##  The condor_schedd can renice the condor_shadow processes on your
##  submit machines.  How "nice" do you want the shadows? (1-19).
##  The higher the number, the lower priority the shadows have.
# SHADOW_RENICE_INCREMENT	= 0

## The condor_schedd can renice scheduler universe processes
## (e.g. DAGMan) on your submit machines.  How "nice" do you want the
## scheduler universe processes? (1-19).  The higher the number, the
## lower priority the processes have.
# SCHED_UNIV_RENICE_INCREMENT = 0

##  By default, when the schedd fails to start an idle job, it will
##  not try to start any other idle jobs in the same cluster during
##  that negotiation cycle.  This makes negotiation much more
##  efficient for large job clusters.  However, in some cases other
##  jobs in the cluster can be started even though an earlier job
##  can't.  For example, the jobs' requirements may differ, because of
##  different disk space, memory, or operating system requirements.
##  Or, machines may be willing to run only some jobs in the cluster,
##  because their requirements reference the jobs' virtual memory size
##  or other attribute.  Setting NEGOTIATE_ALL_JOBS_IN_CLUSTER to True
##  will force the schedd to try to start all idle jobs in each
##  negotiation cycle.  This will make negotiation cycles last longer,
##  but it will ensure that all jobs that can be started will be
##  started.
#NEGOTIATE_ALL_JOBS_IN_CLUSTER = False

## This setting controls how often, in seconds, the schedd considers
## periodic job actions given by the user in the submit file.
## (Currently, these are periodic_hold, periodic_release, and periodic_remove.)
#PERIODIC_EXPR_INTERVAL = 60

######
## Queue management settings:
######
##  How often should the schedd truncate it's job queue transaction
##  log?  (Specified in seconds, once a day is the default.)
#QUEUE_CLEAN_INTERVAL	= 86400

##  How often should the schedd commit "wall clock" run time for jobs
##  to the queue, so run time statistics remain accurate when the
##  schedd crashes?  (Specified in seconds, once per hour is the
##  default.  Set to 0 to disable.)
#WALL_CLOCK_CKPT_INTERVAL = 3600

##  What users do you want to grant super user access to this job
##  queue?  (These users will be able to remove other user's jobs). 
##  By default, this only includes root.
QUEUE_SUPER_USERS	= root, condor


##--------------------------------------------------------------------
##  condor_shadow
##--------------------------------------------------------------------
##  If the shadow is unable to read a checkpoint file from the
##  checkpoint server, it keeps trying only if the job has accumulated
##  more than MAX_DISCARDED_RUN_TIME seconds of CPU usage.  Otherwise,
##  the job is started from scratch.  Defaults to 1 hour.  This
##  setting is only used if USE_CKPT_SERVER (from above) is True.
#MAX_DISCARDED_RUN_TIME = 3600 

##  Should periodic checkpoints be compressed?
#COMPRESS_PERIODIC_CKPT = False

##  Should vacate checkpoints be compressed?
#COMPRESS_VACATE_CKPT = False

##  Should we commit the application's dirty memory pages to swap
##  space during a periodic checkpoint?
#PERIODIC_MEMORY_SYNC = False

##  Should we write vacate checkpoints slowly?  If nonzero, this
##  parameter specifies the speed at which vacate checkpoints should
##  be written, in kilobytes per second.
#SLOW_CKPT_SPEED = 0

##  How often should the shadow update the job queue with job
##  attributes that periodically change?  Specified in seconds.
#SHADOW_QUEUE_UPDATE_INTERVAL = 15 * 60

##  Should the shadow wait to update certain job attributes for the
##  next periodic update, or should it immediately these update
##  attributes as they change?  Due to performance concerns of
##  aggressive updates to a busy condor_schedd, the default is True.
#SHADOW_LAZY_QUEUE_UPDATE = TRUE


##--------------------------------------------------------------------
##  condor_starter
##--------------------------------------------------------------------
##  The condor_starter can renice the processes from remote Condor
##  jobs on your execute machines.  If you want this, uncomment the
##  following entry and set it to how "nice" you want the user
##  jobs. (1-19)  The larger the number, the lower priority the
##  process gets on your machines.
##  Note on Win32 platforms, this number needs to be greater than
##  zero (i.e. the job must be reniced) or the mechanism that 
##  monitors CPU load on Win32 systems will give erratic results.
#JOB_RENICE_INCREMENT	= 10

##  Should the starter do local logging to its own log file, or send
##  debug information back to the condor_shadow where it will end up
##  in the ShadowLog? 
#STARTER_LOCAL_LOGGING	= TRUE

##  If the UID_DOMAIN settings match on both the execute and submit
##  machines, but the UID of the user who submitted the job isn't in
##  the passwd file of the execute machine, the starter will normally
##  exit with an error.  Do you want the starter to just start up the
##  job with the specified UID, even if it's not in the passwd file?
#SOFT_UID_DOMAIN	= FALSE


##--------------------------------------------------------------------
##  condor_procd
##--------------------------------------------------------------------
##  
# the path to the procd binary
#
PROCD = $(SBIN)/condor_procd

# the path to the procd "address"
#   - on UNIX this will be a named pipe; we'll put it in the
#     $(LOCK) directory by default (note that multiple named pipes
#     will be created in this directory for when the procd responds
#     to its clients)
#   - on Windows, this will be a named pipe as well (but named pipes on
#     Windows are not even close to the same thing as named pipes on
#     UNIX); the name will be something like:
#         \\.\pipe\condor_procd
#
PROCD_ADDRESS = $(RUN)/procd_pipe

# The procd currently uses a very simplistic logging system. Since this
# log will not be rotated like other Condor logs, it is only recommended
# to set PROCD_LOG when attempting to debug a problem. In other Condor
# daemons, turning on D_PROCFAMILY will result in that daemon logging
# all of its interactions with the ProcD.
#
#PROCD_LOG = $(LOG)/ProcLog

# This is the maximum period that the procd will use for taking
# snapshots (the actual period may be lower if a condor daemon registers
# a family for which it wants more frequent snapshots)
#
PROCD_MAX_SNAPSHOT_INTERVAL = 60

# On Windows, we send a process a "soft kill" via a WM_CLOSE message.
# This binary is used by the ProcD (and other Condor daemons if PRIVSEP
# is not enabled) to help when sending soft kills.
WINDOWS_SOFTKILL = $(SBIN)/condor_softkill

##--------------------------------------------------------------------
##  condor_submit
##--------------------------------------------------------------------
##  If you want condor_submit to automatically append an expression to
##  the Requirements expression or Rank expression of jobs at your
##  site, uncomment these entries.
#APPEND_REQUIREMENTS	= (expression to append job requirements)
#APPEND_RANK		= (expression to append job rank)

##  If you want expressions only appended for either standard or
##  vanilla universe jobs, you can uncomment these entries.  If any of
##  them are defined, they are used for the given universe, instead of
##  the generic entries above.
#APPEND_REQ_VANILLA	= (expression to append to vanilla job requirements)
#APPEND_REQ_STANDARD	= (expression to append to standard job requirements)
#APPEND_RANK_STANDARD	= (expression to append to vanilla job rank)
#APPEND_RANK_VANILLA	= (expression to append to standard job rank)

##  This can be used to define a default value for the rank expression
##  if one is not specified in the submit file.
#DEFAULT_RANK	        = (default rank expression for all jobs)

##  If you want universe-specific defaults, you can use the following
##  entries:
#DEFAULT_RANK_VANILLA	= (default rank expression for vanilla jobs)
#DEFAULT_RANK_STANDARD	= (default rank expression for standard jobs)

##  If you want condor_submit to automatically append expressions to
##  the job ClassAds it creates, you can uncomment and define the
##  SUBMIT_EXPRS setting.  It works just like the STARTD_EXPRS
##  described above with respect to ClassAd vs. config file syntax,
##  strings, etc.  One common use would be to have the full hostname
##  of the machine where a job was submitted placed in the job
##  ClassAd.  You would do this by uncommenting the following lines: 
#MACHINE = "$(FULL_HOSTNAME)"
#SUBMIT_EXPRS = MACHINE

## Condor keeps a buffer of recently-used data for each file an
## application opens.  This macro specifies the default maximum number
## of bytes to be buffered for each open file at the executing
## machine.
#DEFAULT_IO_BUFFER_SIZE = 524288

## Condor will attempt to consolidate small read and write operations
## into large blocks.  This macro specifies the default block size
## Condor will use.
#DEFAULT_IO_BUFFER_BLOCK_SIZE = 32768

##--------------------------------------------------------------------
##  condor_preen 
##--------------------------------------------------------------------
##  Who should condor_preen send email to?
#PREEN_ADMIN		= $(CONDOR_ADMIN)

##  What files should condor_preen leave in the spool directory?
VALID_SPOOL_FILES	= job_queue.log, job_queue.log.tmp, history, \
                          Accountant.log, Accountantnew.log, \
                          local_univ_execute, .quillwritepassword, \
						  .pgpass, \
			  .schedd_address, .schedd_classad

##  What files should condor_preen remove from the log directory?
INVALID_LOG_FILES	= core

##--------------------------------------------------------------------
##  Java parameters:
##--------------------------------------------------------------------
##  If you would like this machine to be able to run Java jobs,
##  then set JAVA to the path of your JVM binary.  If you are not
##  interested in Java, there is no harm in leaving this entry
##  empty or incorrect.

JAVA = /usr/bin/java

##  Some JVMs need to be told the maximum amount of heap memory
##  to offer to the process.  If your JVM supports this, give
##  the argument here, and Condor will fill in the memory amount.
##  If left blank, your JVM will choose some default value,
##  typically 64 MB.  The default (-Xmx) works with the Sun JVM.

JAVA_MAXHEAP_ARGUMENT =

## JAVA_CLASSPATH_DEFAULT gives the default set of paths in which
## Java classes are to be found.  Each path is separated by spaces.
## If your JVM needs to be informed of additional directories, add
## them here.  However, do not remove the existing entries, as Condor
## needs them.

JAVA_CLASSPATH_DEFAULT = $(LIB) $(LIB)/scimark2lib.jar .

##  JAVA_CLASSPATH_ARGUMENT describes the command-line parameter
##  used to introduce a new classpath:

JAVA_CLASSPATH_ARGUMENT = -classpath

##  JAVA_CLASSPATH_SEPARATOR describes the character used to mark
##  one path element from another:

JAVA_CLASSPATH_SEPARATOR = :

##  JAVA_BENCHMARK_TIME describes the number of seconds for which
##  to run Java benchmarks.  A longer time yields a more accurate
##  benchmark, but consumes more otherwise useful CPU time.
##  If this time is zero or undefined, no Java benchmarks will be run.

JAVA_BENCHMARK_TIME = 2

##  If your JVM requires any special arguments not mentioned in
##  the options above, then give them here.

JAVA_EXTRA_ARGUMENTS =

##
##--------------------------------------------------------------------
##  Condor-G settings
##--------------------------------------------------------------------
##  Where is the GridManager binary installed?

GRIDMANAGER			= $(SBIN)/condor_gridmanager
GT2_GAHP			= $(SBIN)/gahp_server
GRID_MONITOR			= $(SBIN)/grid_monitor.sh

##--------------------------------------------------------------------
##  Settings that control the daemon's debugging output:
##--------------------------------------------------------------------
##
## Note that the Gridmanager runs as the User, not a Condor daemon, so 
## all users must have write permssion to the directory that the 
## Gridmanager will use for it's logfile. Our suggestion is to create a
## directory called GridLogs in $(LOG) with UNIX permissions 1777 
## (just like /tmp )
##  Another option is to use /tmp as the location of the GridManager log.
## 

MAX_GRIDMANAGER_LOG	= 1000000
GRIDMANAGER_DEBUG	= 

GRIDMANAGER_LOG = $(LOG)/GridmanagerLog.$(USERNAME)
GRIDMANAGER_LOCK = $(LOCK)/GridmanagerLock.$(USERNAME)

##--------------------------------------------------------------------
##  Various other settings that the Condor-G can use. 
##--------------------------------------------------------------------

## For grid-type gt2 jobs (pre-WS GRAM), limit the number of jobmanager
## processes the gridmanager will let run on the headnode. Letting too
## many jobmanagers run causes severe load on the headnode.
GRIDMANAGER_MAX_JOBMANAGERS_PER_RESOURCE = 10

## If we're talking to a Globus 2.0 resource, Condor-G will use the new
## version of the GRAM protocol. The first option is how often to check the
## proxy on the submit site of things. If the GridManager discovers a new
## proxy, it will restart itself and use the new proxy for all future 
## jobs launched. In seconds,  and defaults to 10 minutes
#GRIDMANAGER_CHECKPROXY_INTERVAL = 600

## The GridManager will shut things down 3 minutes before loosing Contact
## because of an expired proxy. 
## In seconds, and defaults to 3 minutes
#GRDIMANAGER_MINIMUM_PROXY_TIME  = 180

## Condor requires that each submitted job be designated to run under a
## particular "universe". 
##
## If no universe is specificed in the submit file, Condor must pick one
## for the job to use. By default, it chooses the "vanilla" universe. 
## The default can be overridden in the config file with the DEFAULT_UNIVERSE
## setting, which is a string to insert into a job submit description if the
## job does not try and define it's own universe
##
#DEFAULT_UNIVERSE = vanilla

#
# The Cred_min_time_left is the first-pass at making sure that Condor-G
# does not submit your job without it having enough time left for the 
# job to finish. For example, if you have a job that runs for 20 minutes, and
# you might spend 40 minutes in the queue, it's a bad idea to submit with less
# than an hour left before your proxy expires.
# 2 hours seemed like a reasonable default.
#
CRED_MIN_TIME_LEFT		= 120 


## 
## The GridMonitor allows you to submit many more jobs to a GT2 GRAM server
## than is normally possible.
#ENABLE_GRID_MONITOR = TRUE

##
## When an error occurs with the GridMonitor, how long should the
## gridmanager wait before trying to submit a new GridMonitor job?
## The default is 1 hour (3600 seconds).
#GRID_MONITOR_DISABLE_TIME = 3600

##
## The location of the wrapper for invoking
## Condor GAHP server
##
CONDOR_GAHP = $(SBIN)/condor_c-gahp
CONDOR_GAHP_WORKER = $(SBIN)/condor_c-gahp_worker_thread

##
## The Condor GAHP server has it's own log.  Like the Gridmanager, the
## GAHP server is run as the User, not a Condor daemon, so all users must 
## have write permssion to the directory used for the logfile. Our 
## suggestion is to create a directory called GridLogs in $(LOG) with 
## UNIX permissions 1777 (just like /tmp )
## Another option is to use /tmp as the location of the CGAHP log.
## 
MAX_C_GAHP_LOG	= 1000000

#C_GAHP_LOG = $(LOG)/GridLogs/CGAHPLog.$(USERNAME)
C_GAHP_LOG = /tmp/CGAHPLog.$(USERNAME)
C_GAHP_LOCK = /tmp/CGAHPLock.$(USERNAME)
C_GAHP_WORKER_THREAD_LOG = /tmp/CGAHPWorkerLog.$(USERNAME)
C_GAHP_WORKER_THREAD_LOCK = /tmp/CGAHPWorkerLock.$(USERNAME)

##
## The location of the wrapper for invoking
## GT4 GAHP server
##
GT4_GAHP = $(SBIN)/gt4_gahp

##
## The location of GT4 files. This should normally be lib/gt4
##
GT4_LOCATION = $(LIB)/gt4

##
## The location of the wrapper for invoking
## GT4 GAHP server
##
GT42_GAHP = $(SBIN)/gt42_gahp

##
## The location of GT4 files. This should normally be lib/gt4
##
GT42_LOCATION = $(LIB)/gt42

##
## gt4 gram requires a gridftp server to perform file transfers.
## If GRIDFTP_URL_BASE is set, then Condor assumes there is a gridftp
## server set up at that URL suitable for its use. Otherwise, Condor
## will start its own gridftp servers as needed, using the binary
## pointed at by GRIDFTP_SERVER. GRIDFTP_SERVER_WRAPPER points to a
## wrapper script needed to properly set the path to the gridmap file.
##
#GRIDFTP_URL_BASE = gsiftp://$(FULL_HOSTNAME)
GRIDFTP_SERVER = $(LIBEXEC)/globus-gridftp-server
GRIDFTP_SERVER_WRAPPER = $(LIBEXEC)/gridftp_wrapper.sh

##
## Location of the PBS/LSF gahp and its associated binaries
##
GLITE_LOCATION = $(LIB)/glite
PBS_GAHP = $(GLITE_LOCATION)/bin/batch_gahp
LSF_GAHP = $(GLITE_LOCATION)/bin/batch_gahp

##
## The location of the wrapper for invoking the Unicore GAHP server
##
UNICORE_GAHP = $(SBIN)/unicore_gahp

##
## The location of the wrapper for invoking the NorduGrid GAHP server
##
NORDUGRID_GAHP = $(SBIN)/nordugrid_gahp

## The location of the CREAM GAHP server
CREAM_GAHP = $(SBIN)/cream_gahp

## Condor-G and CredD can use MyProxy to refresh GSI proxies which are
## about to expire.
#MYPROXY_GET_DELEGATION = /path/to/myproxy-get-delegation

##
## EC2: Universe = Grid, Grid_Resource = Amazon
##

## The location of the amazon_gahp program, required
AMAZON_GAHP = $(SBIN)/amazon_gahp

## Location of log files, useful for debugging, must be in
## a directory writable by any user, such as /tmp
#AMAZON_GAHP_DEBUG = D_FULLDEBUG
AMAZON_GAHP_LOG = /tmp/AmazonGahpLog.$(USERNAME)

## The number of seconds between status update requests to EC2. You can
## make this short (5 seconds) if you want Condor to respond quickly to
## instances as they terminate, or you can make it long (300 seconds = 5
## minutes) if you know your instances will run for awhile and don't mind
## delay between when they stop and when Condor responds to them
## stopping.
GRIDMANAGER_JOB_PROBE_INTERVAL = 300

## As of this writing Amazon EC2 has a hard limit of 20 concurrently
## running instances, so a limit of 20 is imposed so the GridManager
## does not waste its time sending requests that will be rejected.
GRIDMANAGER_MAX_SUBMITTED_JOBS_PER_RESOURCE_AMAZON = 20

##
##--------------------------------------------------------------------
##  condor_credd credential managment daemon
##--------------------------------------------------------------------
##  Where is the CredD binary installed?
CREDD				= $(SBIN)/condor_credd

##  When the credd starts up, it can place it's address (IP and port)
##  into a file.  This way, tools running on the local machine don't
##  need an additional "-n host:port" command line option.  This
##  feature can be turned off by commenting out this setting.
CREDD_ADDRESS_FILE	= $(LOG)/.credd_address

##  Specify a remote credd server here,
#CREDD_HOST  = $(CONDOR_HOST):$(CREDD_PORT)

## CredD startup arguments
## Start the CredD on a well-known port.  Uncomment to to simplify
## connecting to a remote CredD.  Note: that this interface may change
## in a future release.
CREDD_PORT			= 9620
CREDD_ARGS			= -p $(CREDD_PORT) -f

## CredD daemon debugging log
CREDD_LOG			= $(LOG)/CredLog
CREDD_DEBUG			= D_FULLDEBUG
MAX_CREDD_LOG		= 4000000

## The credential owner submits the credential.  This list specififies
## other user who are also permitted to see all credentials.  Defaults
## to root on Unix systems, and Administrator on Windows systems.
#CRED_SUPER_USERS = 

## Credential storage location.  This directory must exist
## prior to starting condor_credd.  It is highly recommended to
## restrict access permissions to _only_ the directory owner.
CRED_STORE_DIR = $(LOCAL_DIR)/cred_dir

## Index file path of saved credentials.
## This file will be automatically created if it does not exist.
#CRED_INDEX_FILE = $(CRED_STORE_DIR/cred-index

## condor_credd  will attempt to refresh credentials when their
## remaining lifespan is less than this value.  Units = seconds.
#DEFAULT_CRED_EXPIRE_THRESHOLD = 3600

## condor-credd periodically checks remaining lifespan of stored
## credentials, at this interval.
#CRED_CHECK_INTERVAL = 60

##
##--------------------------------------------------------------------
##  Stork data placment server
##--------------------------------------------------------------------
##  Where is the Stork binary installed?
STORK				= $(SBIN)/stork_server

##  When Stork starts up, it can place it's address (IP and port)
##  into a file.  This way, tools running on the local machine don't
##  need an additional "-n host:port" command line option.  This
##  feature can be turned off by commenting out this setting.
STORK_ADDRESS_FILE = $(LOG)/.stork_address

##  Specify a remote Stork server here,
#STORK_HOST  = $(CONDOR_HOST):$(STORK_PORT)

## STORK_LOG_BASE specifies the basename for heritage Stork log files.
## Stork uses this macro to create the following output log files:
## $(STORK_LOG_BASE): Stork server job queue classad collection
## journal file.
## $(STORK_LOG_BASE).history: Used to track completed jobs.
## $(STORK_LOG_BASE).user_log: User level log, also used by DAGMan.
STORK_LOG_BASE		= $(LOG)/Stork

## Modern Condor DaemonCore logging feature.
STORK_LOG = $(LOG)/StorkLog
STORK_DEBUG = D_FULLDEBUG
MAX_STORK_LOG = 4000000

## Stork startup arguments
## Start Stork on a well-known port.  Uncomment to to simplify
## connecting to a remote Stork.  Note: that this interface may change
## in a future release.
#STORK_PORT			= 34048
STORK_PORT			= 9621
STORK_ARGS = -p $(STORK_PORT) -f -Serverlog $(STORK_LOG_BASE)

## Stork environment.  Stork modules may require external programs and
## shared object libraries.  These are located using the PATH and
## LD_LIBRARY_PATH environments.  Further, some modules may require
## further specific environments.  By default, Stork inherits a full
## environment when invoked from condor_master or the shell.  If the
## default environment is not adequate for all Stork modules, specify
## a replacement environment here.  This environment will be set by
## condor_master before starting Stork, but does not apply if Stork is
## started directly from the command line.
#STORK_ENVIRONMENT = TMP=/tmp;CONDOR_CONFIG=/special/config;PATH=/lib

## Limits the number of concurrent data placements handled by Stork.
#STORK_MAX_NUM_JOBS = 5

## Limits the number of retries for a failed data placement.
#STORK_MAX_RETRY = 5

## Limits the run time for a data placement job, after which the
## placement is considered failed.
#STORK_MAXDELAY_INMINUTES = 10

## Temporary credential storage directory used by Stork.
#STORK_TMP_CRED_DIR = /tmp

## Directory containing Stork modules.
#STORK_MODULE_DIR = $(LIBEXEC)

##
##--------------------------------------------------------------------
##  Quill Job Queue Mirroring Server
##--------------------------------------------------------------------
##  Where is the Quill binary installed and what arguments should be passed?
QUILL = $(SBIN)/condor_quill
#QUILL_ARGS =

# Where is the log file for the quill daemon?
QUILL_LOG = $(LOG)/QuillLog

# The identification and location of the quill daemon for local clients.
QUILL_ADDRESS_FILE = $(LOG)/.quill_address

# If this is set to true, then the rest of the QUILL arguments must be defined
# for quill to function. If it is Fase or left undefined, then quill will not
# be consulted by either the scheduler or the tools, but in the case of a 
# remote quill query where the local client has quill turned off, but the
# remote client has quill turned on, things will still function normally.
#QUILL_ENABLED = TRUE

# 
# If Quill is enabled, by default it will only mirror the current job
# queue into the database. For historical jobs, and classads from other 
# sources, the SQL Log must be enabled.
#QUILL_USE_SQL_LOG=FALSE

#
# The SQL Log can be enabled on a per-daemon basis. For example, to collect
# historical job information, but store no information about execute machines,
# uncomment these two lines
#QUILL_USE_SQL_LOG = FALSE 
#SCHEDD.QUILL_USE_SQL_LOG = TRUE

# This will be the name of a quill daemon using this config file. This name
# should not conflict with any other quill name--or schedd name. 
#QUILL_NAME = quill@postgresql-server.machine.com

# The Postgreql server requires usernames that can manipulate tables. This will
# be the username associated with this instance of the quill daemon mirroring
# a schedd's job queue. Each quill daemon must have a unique username 
# associated with it otherwise multiple quill daemons will corrupt the data
# held under an indentical user name.
#QUILL_DB_NAME = name_of_db

# The required password for the DB user which quill will use to read 
# information from the database about the queue.
#QUILL_DB_QUERY_PASSWORD = foobar

# What kind of database server is this?
# For now, only PGSQL is supported
#QUILL_DB_TYPE = PGSQL

# The machine and port of the postgres server.
# Although this says IP Addr, it can be a DNS name. 
# It must match whatever format you used for the .pgpass file, however
#QUILL_DB_IP_ADDR = machine.domain.com:5432

# The login to use to attach to the database for updating information.
# There should be an entry in file $SPOOL/.pgpass that gives the password 
# for this login id.
#QUILL_DB_USER = quillwriter

# Polling period, in seconds, for when quill reads transactions out of the
# schedd's job queue log file and puts them into the database.
#QUILL_POLLING_PERIOD = 10

# Allows or disallows a remote query to the quill daemon and database
# which is reading this log file. Defaults to true.
#QUILL_IS_REMOTELY_QUERYABLE = TRUE

# Add debugging flags to here if you need to debug quill for some reason.
#QUILL_DEBUG = D_FULLDEBUG

# Number of seconds the master should wait for the Quill daemon to respond 
# before killing it. This number might need to be increased for very 
# large  logfiles.
# The default is 3600 (one hour), but kicking it up to a few hours won't hurt
#QUILL_NOT_RESPONDING_TIMEOUT = 3600

# Should Quill hold open a database connection to the DBMSD? 
# Each open connection consumes resources at the server, so large pools
# (100 or more machines) should set this variable to FALSE. Note the
# default is TRUE.
#QUILL_MAINTAIN_DB_CONN = TRUE

##
##--------------------------------------------------------------------
##  Database Management Daemon settings
##--------------------------------------------------------------------
##  Where is the DBMSd binary installed and what arguments should be passed?
DBMSD = $(SBIN)/condor_dbmsd
DBMSD_ARGS = -f

# Where is the log file for the quill daemon?
DBMSD_LOG = $(LOG)/DbmsdLog

# Interval between consecutive purging calls (in seconds)
#DATABASE_PURGE_INTERVAL = 86400

# Interval between consecutive database reindexing operations
# This is only used when dbtype = PGSQL
#DATABASE_REINDEX_INTERVAL = 86400

# Number of days before purging resource classad history
# This includes things like machine ads, daemon ads, submitters
#QUILL_RESOURCE_HISTORY_DURATION = 7

# Number of days before purging job run information 
# This includes job events, file transfers, matchmaker matches, etc
# This does NOT include the final job ad. condor_history does not need
# any of this information to work.
#QUILL_RUN_HISTORY_DURATION = 7

# Number of days before purging job classad history
# This is the information needed to run condor_history
#QUILL_JOB_HISTORY_DURATION = 3650

# DB size threshold for warning the condor administrator. This is checked
# after every purge. The size is given in gigabytes.
#QUILL_DBSIZE_LIMIT = 20

# Number of seconds the master should wait for the DBMSD to respond before 
# killing it. This number might need to be increased for very large databases
# The default is 3600 (one hour). 
#DBMSD_NOT_RESPONDING_TIMEOUT = 3600

##
##--------------------------------------------------------------------
##  VM Universe Parameters
##--------------------------------------------------------------------
## Where is the Condor VM-GAHP installed? (Required)
VM_GAHP_SERVER = $(SBIN)/condor_vm-gahp

## If the VM-GAHP is to have its own log, define 
## the location of log file.
##
## Optionally, if you do NOT define VM_GAHP_LOG, logs of VM-GAHP will 
## be stored in the starter's log file. 
## However, on Windows machine you must always define VM_GAHP_LOG. 
#
VM_GAHP_LOG	= $(LOG)/VMGahpLog
MAX_VM_GAHP_LOG	= 1000000
#VM_GAHP_DEBUG = D_FULLDEBUG

## What kind of virtual machine program will be used for 
## the VM universe?
## The two options are vmware and xen.  (Required)
#VM_TYPE = vmware

## How much memory can be used for the VM universe? (Required)
## This value is the maximum amount of memory that can be used by the 
## virtual machine program.
#VM_MEMORY = 128

## Want to support networking for VM universe?
## Default value is FALSE
#VM_NETWORKING = FALSE

## What kind of networking types are supported?
##
## If you set VM_NETWORKING to TRUE, you must define this parameter.
## VM_NETWORKING_TYPE = nat
## VM_NETWORKING_TYPE = bridge
## VM_NETWORKING_TYPE = nat, bridge
##
## If multiple networking types are defined, you may define 
## VM_NETWORKING_DEFAULT_TYPE for default networking type. 
## Otherwise, nat is used for default networking type.
## VM_NETWORKING_DEFAULT_TYPE = nat
#VM_NETWORKING_DEFAULT_TYPE = nat
#VM_NETWORKING_TYPE = nat

## In default, the number of possible virtual machines is same as
## NUM_CPUS.
## Since too many virtual machines can cause the system to be too slow
## and lead to unexpected problems, limit the number of running 
## virtual machines on this machine with
#VM_MAX_NUMBER = 2

## When a VM universe job is started, a status command is sent
## to the VM-GAHP to see if the job is finished.
## If the interval between checks is too short, it will consume 
## too much of the CPU. If the VM-GAHP fails to get status 5 times in a row, 
## an error will be reported to startd, and then startd will check 
## the availability of VM universe.
## Default value is 60 seconds and minimum value is 30 seconds
#VM_STATUS_INTERVAL = 60

## How long will we wait for a request sent to the VM-GAHP to be completed?
## If a request is not completed within the timeout, an error will be reported 
## to the startd, and then the startd will check 
## the availability of vm universe.  Default value is 5 mins.
#VM_GAHP_REQ_TIMEOUT = 300

## When VMware or Xen causes an error, the startd will disable the
## VM universe.  However, because some errors are just transient,
## we will test one more
## whether vm universe is still unavailable after some time.
## In default, startd will recheck vm universe after 10 minutes.
## If the test also fails, vm universe will be disabled. 
#VM_RECHECK_INTERVAL = 600

## Usually, when we suspend a VM, the memory being used by the VM
## will be saved into a file and then freed.
## However, when we use soft suspend, neither saving nor memory freeing
## will occur.
## For VMware, we send SIGSTOP to a process for VM in order to 
## stop the VM temporarily and send SIGCONT to resume the VM.
## For Xen, we pause CPU. Pausing CPU doesn't save the memory of VM 
## into a file. It only stops the execution of a VM temporarily.
#VM_SOFT_SUSPEND = TRUE

## If Condor runs as root and a job comes from a different UID domain, 
## Condor generally uses "nobody", unless SLOTx_USER is defined. 
## If "VM_UNIV_NOBODY_USER" is defined, a VM universe job will run 
## as the user defined in "VM_UNIV_NOBODY_USER" instead of "nobody". 
##
## Notice: In VMware VM universe, "nobody" can not create a VMware VM. 
## So we need to define "VM_UNIV_NOBODY_USER" with a regular user. 
## For VMware, the user defined in "VM_UNIV_NOBODY_USER" must have a
## home directory.  So SOFT_UID_DOMAIN doesn't work for VMware VM universe job.
## If neither "VM_UNIV_NOBODY_USER" nor "SLOTx_VMUSER"/"SLOTx_USER" is defined, 
## VMware VM universe job will run as "condor" instead of "nobody".
## As a result, the preference of local users for a VMware VM universe job
## which comes from the different UID domain is 
## "VM_UNIV_NOBODY_USER" -> "SLOTx_VMUSER" -> "SLOTx_USER" -> "condor". 
#VM_UNIV_NOBODY_USER = login name of a user who has home directory

## If Condor runs as root and "ALWAYS_VM_UNIV_USE_NOBODY" is set to TRUE, 
## all VM universe jobs will run as a user defined in "VM_UNIV_NOBODY_USER".
#ALWAYS_VM_UNIV_USE_NOBODY = FALSE

##--------------------------------------------------------------------
##  VM Universe Parameters Specific to VMware
##--------------------------------------------------------------------

## Where is perl program? (Required)
VMWARE_PERL = perl

## Where is the Condor script program to control VMware? (Required)
VMWARE_SCRIPT = $(SBIN)/condor_vm_vmware.pl

## Networking parameters for VMware
##
## What kind of VMware networking is used?
##
## If multiple networking types are defined, you may specify different
## parameters for each networking type.
##
## Examples
## (e.g.) VMWARE_NAT_NETWORKING_TYPE = nat
## (e.g.) VMWARE_BRIDGE_NETWORKING_TYPE = bridged
## 
##  If there is no parameter for specific networking type, VMWARE_NETWORKING_TYPE is used.
##
#VMWARE_NAT_NETWORKING_TYPE = nat
#VMWARE_BRIDGE_NETWORKING_TYPE = bridged
VMWARE_NETWORKING_TYPE = nat

## The contents of this file will be inserted into the .vmx file of
## the VMware virtual machine before Condor starts it.
#VMWARE_LOCAL_SETTINGS_FILE = /path/to/file

##--------------------------------------------------------------------
##  VM Universe Parameters common to libvirt controlled vm's (xen & kvm)
##--------------------------------------------------------------------

##  Where is the Condor script program to control Xen & KVM? (Required)
VM_SCRIPT = $(SBIN)/condor_vm_xen.sh

## Networking parameters for Xen & KVM
##
## This parameter is used only for virsh.
##
## A string specifying a script and its arguments that will be run to
## setup a bridging network interface for guests. The interface should
## provide direct access to the host system's LAN, i.e. not be NAT'd on the
## host. 
##
## Example 
##  VM_BRIDGE_SCRIPT = vif-bridge bridge=xenbr0 
#VM_BRIDGE_SCRIPT = vif-bridge bridge=xenbr0

## This is the path to the XML helper command; the libvirt_simple_script.awk
## script just reproduces what Condor already does for the kvm/xen VM
## universe
LIBVIRT_XML_SCRIPT = $(LIBEXEC)/libvirt_simple_script.awk

## This is the optional debugging output file for the xml helper
## script.  Scripts that need to output debugging messages should
## write them to the file specified by this argument, which will be
## passed as the second command line argument when the script is
## executed

#LIBVRT_XML_SCRIPT_ARGS = /dev/stderr

##--------------------------------------------------------------------
##  VM Universe Parameters Specific to Xen
##--------------------------------------------------------------------

##  Where is bootloader for Xen domainU? (Required)
##
##  The bootloader will be used in the case that a kernel image includes
##  a disk image
#XEN_BOOTLOADER = /usr/bin/pygrub

## The contents of this file will be added to the Xen virtual machine
## description that Condor writes.
#XEN_LOCAL_SETTINGS_FILE = /path/to/file

##
##--------------------------------------------------------------------
##  condor_lease_manager lease manager daemon
##--------------------------------------------------------------------
##  Where is the LeaseManager binary installed?
LeaseManager			= $(SBIN)/condor_lease_manager

# Turn on the lease manager
#DAEMON_LIST			= $(DAEMON_LIST), LeaseManager

# The identification and location of the lease manager for local clients.
LeaseManger_ADDRESS_FILE	= $(LOG)/.lease_manager_address

## LeaseManager startup arguments
#LeaseManager_ARGS		= -local-name generic

## LeaseManager daemon debugging log
LeaseManager_LOG		= $(LOG)/LeaseManagerLog
LeaseManager_DEBUG		= D_FULLDEBUG
MAX_LeaseManager_LOG		= 1000000

# Basic parameters
LeaseManager.GETADS_INTERVAL	= 60
LeaseManager.UPDATE_INTERVAL	= 300
LeaseManager.PRUNE_INTERVAL	= 60
LeaseManager.DEBUG_ADS		= False

LeaseManager.CLASSAD_LOG	= $(SPOOL)/LeaseManagerState
#LeaseManager.QUERY_ADTYPE	= Any
#LeaseManager.QUERY_CONSTRAINTS	= target.MyType == "SomeType"
#LeaseManager.QUERY_CONSTRAINTS	= target.TargetType == "SomeType"

##
##--------------------------------------------------------------------
##  condor_ssh_to_job
##--------------------------------------------------------------------
# NOTE: condor_ssh_to_job is not supported under Windows.

# Tell the starter (execute side) whether to allow the job owner or
# queue super user on the schedd from which the job was submitted to
# use condor_ssh_to_job to access the job interactively (e.g. for
# debugging).  TARGET is the job; MY is the machine.
#ENABLE_SSH_TO_JOB = true

# Tell the schedd (submit side) whether to allow the job owner or
# queue super user to use condor_ssh_to_job to access the job
# interactively (e.g. for debugging).  MY is the job; TARGET is not
# defined.
#SCHEDD_ENABLE_SSH_TO_JOB = true

# Command condor_ssh_to_job should use to invoke the ssh client.
# %h --> remote host
# %i --> ssh key file
# %k --> known hosts file
# %u --> remote user
# %x --> proxy command
# %% --> %
#SSH_TO_JOB_SSH_CMD = ssh -oUser=%u -oIdentityFile=%i -oStrictHostKeyChecking=yes -oUserKnownHostsFile=%k -oGlobalKnownHostsFile=%k -oProxyCommand=%x %h

# Additional ssh clients may be configured.  They all have the same
# default as ssh, except for scp, which omits the %h:
#SSH_TO_JOB_SCP_CMD = scp -oUser=%u -oIdentityFile=%i -oStrictHostKeyChecking=yes -oUserKnownHostsFile=%k -oGlobalKnownHostsFile=%k -oProxyCommand=%x

# Path to sshd
#SSH_TO_JOB_SSHD = /usr/sbin/sshd

# Arguments the starter should use to invoke sshd in inetd mode.
# %f --> sshd config file
# %% --> %
#SSH_TO_JOB_SSHD_ARGS = "-i -e -f %f"

# sshd configuration template used by condor_ssh_to_job_sshd_setup.
#SSH_TO_JOB_SSHD_CONFIG_TEMPLATE = $(LIB)/condor_ssh_to_job_sshd_config_template

# Path to ssh-keygen
#SSH_TO_JOB_SSH_KEYGEN = /usr/bin/ssh-keygen

# Arguments to ssh-keygen
# %f --> key file to generate
# %% --> %
#SSH_TO_JOB_SSH_KEYGEN_ARGS = "-N '' -C '' -q -f %f -t rsa"

######################################################################
##
##  Condor HDFS
##
##  This is the default local configuration file for configuring Condor
##  daemon responsible for running services related to hadoop 
##  distributed storage system.You should copy this file to the
##  appropriate location and customize it for your needs.  
##
##  Unless otherwise specified, settings that are commented out show
##  the defaults that are used if you don't define a value.  Settings
##  that are defined here MUST BE DEFINED since they have no default
##  value.
##
######################################################################

######################################################################
## FOLLOWING MUST BE CHANGED
######################################################################

## The location for hadoop installation directory. The default location
## is under 'libexec' directory. The directory pointed by HDFS_HOME 
## should contain a lib folder that contains all the required Jars necessary
## to run HDFS name and data nodes. 
#HDFS_HOME = $(RELEASE_DIR)/libexec/hdfs

## The host and port for hadoop's name node. If this machine is the
## name node (see HDFS_SERVICES) then the specified port will be used
## to run name node. 
HDFS_NAMENODE = example.com:9000
HDFS_NAMENODE_WEB = example.com:8000

## You need to pick one machine as name node by setting this parameter
## to HDFS_NAMENODE. The remaining machines in a storage cluster will
## act as data nodes (HDFS_DATANODE).
HDFS_SERVICES = HDFS_DATANODE

## The two set of directories that are required by HDFS are for name 
## node (HDFS_NAMENODE_DIR) and data node (HDFS_DATANODE_DIR). The 
## directory for name node is only required for a machine running 
## name node service and  is used to store critical meta data for 
## files. The data node needs its directory to store file blocks and 
## their replicas.
HDFS_NAMENODE_DIR = /tmp/hadoop_name
HDFS_DATANODE_DIR = /scratch/tmp/hadoop_data

## Unlike name node address settings (HDFS_NAMENODE), that needs to be 
## well known across the storage cluster, data node can run on any 
## arbitrary port of given host.
#HDFS_DATANODE_ADDRESS = 0.0.0.0:0

####################################################################
## OPTIONAL
#####################################################################

## Sets the log4j debug level. All the emitted debug output from HDFS
## will go in 'hdfs.log' under $(LOG) directory.
#HDFS_LOG4J=DEBUG

## The access to HDFS services both name node and data node can be 
## restricted by specifying IP/host based filters. By default settings
## from ALLOW_READ/ALLOW_WRITE and DENY_READ/DENY_WRITE
## are used to specify allow and deny list. The below two parameters can
## be used to override these settings. Read the Condor manual for 
## specification of these filters.
## WARN: HDFS doesn't make any distinction between read or write based connection.
#HDFS_ALLOW=*
#HDFS_DENY=*

#Fully qualified name for Name node and Datanode class.
#HDFS_NAMENODE_CLASS=org.apache.hadoop.hdfs.server.namenode.NameNode
#HDFS_DATANODE_CLASS=org.apache.hadoop.hdfs.server.datanode.DataNode

## In case an old name for hdfs configuration files is required.
#HDFS_SITE_FILE = hadoop-site.xml

IN_HIGHPORT = 9999
IN_LOWPORT = 9000
SEC_DAEMON_AUTHENTICATION = required
SEC_DAEMON_AUTHENTICATION_METHODS = password 
SEC_CLIENT_AUTHENTICATION_METHODS = password,fs,gsi,kerberos
SEC_PASSWORD_FILE = $(LOCAL_DIR)/condor_credential 
ALLOW_DAEMON = condor_pool@* 