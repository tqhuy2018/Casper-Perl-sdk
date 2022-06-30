# This Makefile is for the GetStateRootHash::GetStateRootHashRPC extension to perl.
#
# It was generated automatically by MakeMaker version
# 7.34 (Revision: 73400) from the contents of
# Makefile.PL. Don't edit this file, edit Makefile.PL instead.
#
#       ANY CHANGES MADE HERE WILL BE LOST!
#
#   MakeMaker ARGV: ()
#

#   MakeMaker Parameters:

#     ABSTRACT => q[lib/GetStateRootHash/GetStateRootHashRPC.pm]
#     AUTHOR => [q[huy <tqhuy2018@gmail.com>]]
#     BUILD_REQUIRES => {  }
#     CONFIGURE_REQUIRES => { ExtUtils::MakeMaker=>q[0] }
#     LICENSE => q[MIT]
#     MIN_PERL_VERSION => q[5.008003]
#     NAME => q[GetStateRootHash::GetStateRootHashRPC]
#     PREREQ_PM => { Test::More=>q[0] }
#     TEST_REQUIRES => { Test::More=>q[0] }
#     VERSION_FROM => q[lib/GetStateRootHash/GetStateRootHashRPC.pm]
#     clean => { FILES=>q[.-*] }
#     dist => { COMPRESS=>q[gzip -9f], SUFFIX=>q[gz] }

# --- MakeMaker post_initialize section:


# --- MakeMaker const_config section:

# These definitions are from config.sh (via /System/Library/Perl/5.30/darwin-thread-multi-2level/Config.pm).
# They may have been overridden via Makefile.PL or on the command line.
AR = ar
CC = cc
CCCDLFLAGS =  
CCDLFLAGS =  
DLEXT = bundle
DLSRC = dl_dlopen.xs
EXE_EXT = 
FULL_AR = /usr/bin/ar
LD = cc
LDDLFLAGS =  -bundle -undefined dynamic_lookup -fstack-protector-strong
LDFLAGS =  -fstack-protector-strong
LIBC = 
LIB_EXT = .a
OBJ_EXT = .o
OSNAME = darwin
OSVERS = 20.0
RANLIB = /usr/bin/ar s
SITELIBEXP = /Library/Perl/5.30
SITEARCHEXP = /Library/Perl/5.30/darwin-thread-multi-2level
SO = dylib
VENDORARCHEXP = /Network/Library/Perl/5.30/darwin-thread-multi-2level
VENDORLIBEXP = /Network/Library/Perl/5.30


# --- MakeMaker constants section:
AR_STATIC_ARGS = cr
DIRFILESEP = /
DFSEP = $(DIRFILESEP)
NAME = GetStateRootHash::GetStateRootHashRPC
NAME_SYM = GetStateRootHash_GetStateRootHashRPC
VERSION = 0.01
VERSION_MACRO = VERSION
VERSION_SYM = 0_01
DEFINE_VERSION = -D$(VERSION_MACRO)=\"$(VERSION)\"
XS_VERSION = 0.01
XS_VERSION_MACRO = XS_VERSION
XS_DEFINE_VERSION = -D$(XS_VERSION_MACRO)=\"$(XS_VERSION)\"
INST_ARCHLIB = blib/arch
INST_SCRIPT = blib/script
INST_BIN = blib/bin
INST_LIB = blib/lib
INST_MAN1DIR = blib/man1
INST_MAN3DIR = blib/man3
MAN1EXT = 1
MAN3EXT = 3pm
INSTALLDIRS = site
DESTDIR = 
PREFIX = $(SITEPREFIX)
PERLPREFIX = /usr
SITEPREFIX = /usr
VENDORPREFIX = /usr/local
INSTALLPRIVLIB = /Library/Perl/Updates/5.30.2
DESTINSTALLPRIVLIB = $(DESTDIR)$(INSTALLPRIVLIB)
INSTALLSITELIB = /Library/Perl/5.30
DESTINSTALLSITELIB = $(DESTDIR)$(INSTALLSITELIB)
INSTALLVENDORLIB = /Network/Library/Perl/5.30
DESTINSTALLVENDORLIB = $(DESTDIR)$(INSTALLVENDORLIB)
INSTALLARCHLIB = /Library/Perl/Updates/5.30.2/darwin-thread-multi-2level
DESTINSTALLARCHLIB = $(DESTDIR)$(INSTALLARCHLIB)
INSTALLSITEARCH = /Library/Perl/5.30/darwin-thread-multi-2level
DESTINSTALLSITEARCH = $(DESTDIR)$(INSTALLSITEARCH)
INSTALLVENDORARCH = /Network/Library/Perl/5.30/darwin-thread-multi-2level
DESTINSTALLVENDORARCH = $(DESTDIR)$(INSTALLVENDORARCH)
INSTALLBIN = /usr/bin
DESTINSTALLBIN = $(DESTDIR)$(INSTALLBIN)
INSTALLSITEBIN = /usr/local/bin
DESTINSTALLSITEBIN = $(DESTDIR)$(INSTALLSITEBIN)
INSTALLVENDORBIN = /usr/local/bin
DESTINSTALLVENDORBIN = $(DESTDIR)$(INSTALLVENDORBIN)
INSTALLSCRIPT = /usr/bin
DESTINSTALLSCRIPT = $(DESTDIR)$(INSTALLSCRIPT)
INSTALLSITESCRIPT = /usr/local/bin
DESTINSTALLSITESCRIPT = $(DESTDIR)$(INSTALLSITESCRIPT)
INSTALLVENDORSCRIPT = /usr/local/bin
DESTINSTALLVENDORSCRIPT = $(DESTDIR)$(INSTALLVENDORSCRIPT)
INSTALLMAN1DIR = /usr/share/man/man1
DESTINSTALLMAN1DIR = $(DESTDIR)$(INSTALLMAN1DIR)
INSTALLSITEMAN1DIR = /usr/local/share/man/man1
DESTINSTALLSITEMAN1DIR = $(DESTDIR)$(INSTALLSITEMAN1DIR)
INSTALLVENDORMAN1DIR = /usr/local/share/man/man1
DESTINSTALLVENDORMAN1DIR = $(DESTDIR)$(INSTALLVENDORMAN1DIR)
INSTALLMAN3DIR = /usr/share/man/man3
DESTINSTALLMAN3DIR = $(DESTDIR)$(INSTALLMAN3DIR)
INSTALLSITEMAN3DIR = /usr/local/share/man/man3
DESTINSTALLSITEMAN3DIR = $(DESTDIR)$(INSTALLSITEMAN3DIR)
INSTALLVENDORMAN3DIR = /usr/local/share/man/man3
DESTINSTALLVENDORMAN3DIR = $(DESTDIR)$(INSTALLVENDORMAN3DIR)
PERL_LIB = /System/Library/Perl/5.30
PERL_ARCHLIB = /System/Library/Perl/5.30/darwin-thread-multi-2level
PERL_ARCHLIBDEP = /System/Library/Perl/5.30/darwin-thread-multi-2level
LIBPERL_A = libperl.a
FIRST_MAKEFILE = Makefile
MAKEFILE_OLD = Makefile.old
MAKE_APERL_FILE = Makefile.aperl
PERLMAINCC = $(CC)
PERL_INC = /System/Library/Perl/5.30/darwin-thread-multi-2level/CORE
PERL_INCDEP = /System/Library/Perl/5.30/darwin-thread-multi-2level/CORE
PERL = "/usr/bin/perl"
FULLPERL = "/usr/bin/perl"
ABSPERL = $(PERL)
PERLRUN = $(PERL)
FULLPERLRUN = $(FULLPERL)
ABSPERLRUN = $(ABSPERL)
PERLRUNINST = $(PERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
FULLPERLRUNINST = $(FULLPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
ABSPERLRUNINST = $(ABSPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
PERL_CORE = 0
PERM_DIR = 755
PERM_RW = 644
PERM_RWX = 755

MAKEMAKER   = /System/Library/Perl/5.30/ExtUtils/MakeMaker.pm
MM_VERSION  = 7.34
MM_REVISION = 73400

# FULLEXT = Pathname for extension directory (eg Foo/Bar/Oracle).
# BASEEXT = Basename part of FULLEXT. May be just equal FULLEXT. (eg Oracle)
# PARENT_NAME = NAME without BASEEXT and no trailing :: (eg Foo::Bar)
# DLBASE  = Basename part of dynamic library. May be just equal BASEEXT.
MAKE = make
FULLEXT = GetStateRootHash/GetStateRootHashRPC
BASEEXT = GetStateRootHashRPC
PARENT_NAME = GetStateRootHash
DLBASE = $(BASEEXT)
VERSION_FROM = lib/GetStateRootHash/GetStateRootHashRPC.pm
OBJECT = 
LDFROM = $(OBJECT)
LINKTYPE = dynamic
BOOTDEP = 

# Handy lists of source code files:
XS_FILES = 
C_FILES  = 
O_FILES  = 
H_FILES  = 
MAN1PODS = 
MAN3PODS = 

SDKROOT := $(shell xcrun --show-sdk-path)
PERL_SYSROOT = $(SDKROOT)

# Where to build things
INST_LIBDIR      = $(INST_LIB)/GetStateRootHash
INST_ARCHLIBDIR  = $(INST_ARCHLIB)/GetStateRootHash

INST_AUTODIR     = $(INST_LIB)/auto/$(FULLEXT)
INST_ARCHAUTODIR = $(INST_ARCHLIB)/auto/$(FULLEXT)

INST_STATIC      = 
INST_DYNAMIC     = 
INST_BOOT        = 

# Extra linker info
EXPORT_LIST        = 
PERL_ARCHIVE       = 
PERL_ARCHIVEDEP    = 
PERL_ARCHIVE_AFTER = 


TO_INST_PM = Build.pl \
	Makefile.pl \
	lib/CLValue/CLParse.pm \
	lib/CLValue/CLType.pm \
	lib/CLValue/CLValue.pm \
	lib/CasperRPC.pm \
	lib/Common/BlockIdentifier.pm \
	lib/Common/ConstValues.pm \
	lib/Common/ErrorException.pm \
	lib/GetAuction/AuctionState.pm \
	lib/GetAuction/GetAuctionInfoRPC.pm \
	lib/GetAuction/GetAuctionInfoResult.pm \
	lib/GetAuction/JsonBid.pm \
	lib/GetAuction/JsonBids.pm \
	lib/GetAuction/JsonDelegator.pm \
	lib/GetAuction/JsonEraValidators.pm \
	lib/GetAuction/JsonValidatorWeights.pm \
	lib/GetBalance/GetBalanceParams.pm \
	lib/GetBalance/GetBalanceResult.pm \
	lib/GetBalance/GetBalanceResultRPC.pm \
	lib/GetBlock/GetBlockRPC.pm \
	lib/GetBlock/GetBlockResult.pm \
	lib/GetBlock/JsonBlock.pm \
	lib/GetBlock/JsonBlockBody.pm \
	lib/GetBlock/JsonBlockHeader.pm \
	lib/GetBlock/JsonEraEnd.pm \
	lib/GetBlock/JsonEraReport.pm \
	lib/GetBlock/JsonProof.pm \
	lib/GetBlock/Reward.pm \
	lib/GetBlock/ValidatorWeight.pm \
	lib/GetBlockTransfers/GetBlockTransfersRPC.pm \
	lib/GetBlockTransfers/GetBlockTransfersResult.pm \
	lib/GetDeploy/Approval.pm \
	lib/GetDeploy/Deploy.pm \
	lib/GetDeploy/DeployHeader.pm \
	lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem.pm \
	lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem_ModuleBytes.pm \
	lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem_StoredContractByHash.pm \
	lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem_StoredContractByName.pm \
	lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem_StoredVersionedContractByHash.pm \
	lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem_StoredVersionedContractByName.pm \
	lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem_Transfer.pm \
	lib/GetDeploy/ExecutableDeployItem/NamedArg.pm \
	lib/GetDeploy/ExecutableDeployItem/RuntimeArgs.pm \
	lib/GetDeploy/ExecutionResult/CasperOperation.pm \
	lib/GetDeploy/ExecutionResult/CasperTransform.pm \
	lib/GetDeploy/ExecutionResult/ExecutionEffect.pm \
	lib/GetDeploy/ExecutionResult/ExecutionResult.pm \
	lib/GetDeploy/ExecutionResult/JsonExecutionResult.pm \
	lib/GetDeploy/ExecutionResult/Transform/Bid.pm \
	lib/GetDeploy/ExecutionResult/Transform/CasperTransfer.pm \
	lib/GetDeploy/ExecutionResult/Transform/Delegator.pm \
	lib/GetDeploy/ExecutionResult/Transform/DeployInfo.pm \
	lib/GetDeploy/ExecutionResult/Transform/EraInfo.pm \
	lib/GetDeploy/ExecutionResult/Transform/NamedKey.pm \
	lib/GetDeploy/ExecutionResult/Transform/SeigniorageAllocation.pm \
	lib/GetDeploy/ExecutionResult/Transform/UnbondingPurse.pm \
	lib/GetDeploy/ExecutionResult/Transform/VestingSchedule.pm \
	lib/GetDeploy/ExecutionResult/Transform/Withdraw.pm \
	lib/GetDeploy/ExecutionResult/TransformEntry.pm \
	lib/GetDeploy/GetDeployParams.pm \
	lib/GetDeploy/GetDeployRPC.pm \
	lib/GetDeploy/GetDeployResult.pm \
	lib/GetDictionaryItem/DIAccountNamedKey.pm \
	lib/GetDictionaryItem/DIContractNamedKey.pm \
	lib/GetDictionaryItem/DIDictionary.pm \
	lib/GetDictionaryItem/DIURef.pm \
	lib/GetDictionaryItem/DictionaryIdentifier.pm \
	lib/GetDictionaryItem/GetDictionaryItemParams.pm \
	lib/GetDictionaryItem/GetDictionaryItemRPC.pm \
	lib/GetDictionaryItem/GetDictionaryItemResult.pm \
	lib/GetEraInfoBySwitchBlock/EraSummary.pm \
	lib/GetEraInfoBySwitchBlock/GetEraInfoBySwitchBlockRPC.pm \
	lib/GetEraInfoBySwitchBlock/GetEraInfoResult.pm \
	lib/GetItem/GetItemParams.pm \
	lib/GetItem/GetItemRPC.pm \
	lib/GetItem/GetItemResult.pm \
	lib/GetPeers/GetPeerRPC.pm \
	lib/GetPeers/GetPeersResult.pm \
	lib/GetPeers/PeerEntry.pm \
	lib/GetStateRootHash/GetStateRootHashRPC.pm \
	lib/GetStatus/GetStatusRPC.pm \
	lib/GetStatus/GetStatusResult.pm \
	lib/GetStatus/MinimalBlockInfo.pm \
	lib/GetStatus/NextUpgrade.pm \
	lib/StoredValue/Account.pm \
	lib/StoredValue/ActionThresholds.pm \
	lib/StoredValue/AssociatedKey.pm \
	lib/StoredValue/CasperContract.pm \
	lib/StoredValue/ContractPackage.pm \
	lib/StoredValue/ContractVersion.pm \
	lib/StoredValue/DisabledVersion.pm \
	lib/StoredValue/EntryPoint.pm \
	lib/StoredValue/EntryPointAccess.pm \
	lib/StoredValue/Groups.pm \
	lib/StoredValue/Parameter.pm \
	lib/StoredValue/StoredValue.pm


# --- MakeMaker platform_constants section:
MM_Unix_VERSION = 7.34
PERL_MALLOC_DEF = -DPERL_EXTMALLOC_DEF -Dmalloc=Perl_malloc -Dfree=Perl_mfree -Drealloc=Perl_realloc -Dcalloc=Perl_calloc


# --- MakeMaker tool_autosplit section:
# Usage: $(AUTOSPLITFILE) FileToSplit AutoDirToSplitInto
AUTOSPLITFILE = $(ABSPERLRUN)  -e 'use AutoSplit;  autosplit($$$$ARGV[0], $$$$ARGV[1], 0, 1, 1)' --



# --- MakeMaker tool_xsubpp section:


# --- MakeMaker tools_other section:
SHELL = /bin/sh
CHMOD = chmod
CP = cp
MV = mv
NOOP = $(TRUE)
NOECHO = @
RM_F = rm -f
RM_RF = rm -rf
TEST_F = test -f
TOUCH = touch
UMASK_NULL = umask 0
DEV_NULL = > /dev/null 2>&1
MKPATH = $(ABSPERLRUN) -MExtUtils::Command -e 'mkpath' --
EQUALIZE_TIMESTAMP = $(ABSPERLRUN) -MExtUtils::Command -e 'eqtime' --
FALSE = false
TRUE = true
ECHO = echo
ECHO_N = echo -n
UNINST = 0
VERBINST = 0
MOD_INSTALL = $(ABSPERLRUN) -MExtUtils::Install -e 'install([ from_to => {@ARGV}, verbose => '\''$(VERBINST)'\'', uninstall_shadows => '\''$(UNINST)'\'', dir_mode => '\''$(PERM_DIR)'\'' ]);' --
DOC_INSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'perllocal_install' --
UNINSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'uninstall' --
WARN_IF_OLD_PACKLIST = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'warn_if_old_packlist' --
MACROSTART = 
MACROEND = 
USEMAKEFILE = -f
FIXIN = $(ABSPERLRUN) -MExtUtils::MY -e 'MY->fixin(shift)' --
CP_NONEMPTY = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'cp_nonempty' --


# --- MakeMaker makemakerdflt section:
makemakerdflt : all
	$(NOECHO) $(NOOP)


# --- MakeMaker dist section:
TAR = COPY_EXTENDED_ATTRIBUTES_DISABLE=1 COPYFILE_DISABLE=1 tar
TARFLAGS = cvf
ZIP = zip
ZIPFLAGS = -r
COMPRESS = gzip -9f
SUFFIX = .gz
SHAR = shar
PREOP = $(NOECHO) $(NOOP)
POSTOP = $(NOECHO) $(NOOP)
TO_UNIX = $(NOECHO) $(NOOP)
CI = ci -u
RCS_LABEL = rcs -Nv$(VERSION_SYM): -q
DIST_CP = best
DIST_DEFAULT = tardist
DISTNAME = GetStateRootHash-GetStateRootHashRPC
DISTVNAME = GetStateRootHash-GetStateRootHashRPC-0.01


# --- MakeMaker macro section:


# --- MakeMaker depend section:


# --- MakeMaker cflags section:


# --- MakeMaker const_loadlibs section:


# --- MakeMaker const_cccmd section:


# --- MakeMaker post_constants section:


# --- MakeMaker pasthru section:

PASTHRU = LIBPERL_A="$(LIBPERL_A)"\
	LINKTYPE="$(LINKTYPE)"\
	PREFIX="$(PREFIX)"\
	PASTHRU_DEFINE='$(DEFINE) $(PASTHRU_DEFINE)'\
	PASTHRU_INC='$(INC) $(PASTHRU_INC)'


# --- MakeMaker special_targets section:
.SUFFIXES : .xs .c .C .cpp .i .s .cxx .cc $(OBJ_EXT)

.PHONY: all config static dynamic test linkext manifest blibdirs clean realclean disttest distdir pure_all subdirs clean_subdirs makemakerdflt manifypods realclean_subdirs subdirs_dynamic subdirs_pure_nolink subdirs_static subdirs-test_dynamic subdirs-test_static test_dynamic test_static



# --- MakeMaker c_o section:


# --- MakeMaker xs_c section:


# --- MakeMaker xs_o section:


# --- MakeMaker top_targets section:
all :: pure_all manifypods
	$(NOECHO) $(NOOP)

pure_all :: config pm_to_blib subdirs linkext
	$(NOECHO) $(NOOP)

	$(NOECHO) $(NOOP)

subdirs :: $(MYEXTLIB)
	$(NOECHO) $(NOOP)

config :: $(FIRST_MAKEFILE) blibdirs
	$(NOECHO) $(NOOP)

help :
	perldoc ExtUtils::MakeMaker


# --- MakeMaker blibdirs section:
blibdirs : $(INST_LIBDIR)$(DFSEP).exists $(INST_ARCHLIB)$(DFSEP).exists $(INST_AUTODIR)$(DFSEP).exists $(INST_ARCHAUTODIR)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists $(INST_SCRIPT)$(DFSEP).exists $(INST_MAN1DIR)$(DFSEP).exists $(INST_MAN3DIR)$(DFSEP).exists
	$(NOECHO) $(NOOP)

# Backwards compat with 6.18 through 6.25
blibdirs.ts : blibdirs
	$(NOECHO) $(NOOP)

$(INST_LIBDIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_LIBDIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_LIBDIR)
	$(NOECHO) $(TOUCH) $(INST_LIBDIR)$(DFSEP).exists

$(INST_ARCHLIB)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHLIB)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHLIB)
	$(NOECHO) $(TOUCH) $(INST_ARCHLIB)$(DFSEP).exists

$(INST_AUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_AUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_AUTODIR)
	$(NOECHO) $(TOUCH) $(INST_AUTODIR)$(DFSEP).exists

$(INST_ARCHAUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHAUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHAUTODIR)
	$(NOECHO) $(TOUCH) $(INST_ARCHAUTODIR)$(DFSEP).exists

$(INST_BIN)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_BIN)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_BIN)
	$(NOECHO) $(TOUCH) $(INST_BIN)$(DFSEP).exists

$(INST_SCRIPT)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_SCRIPT)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_SCRIPT)
	$(NOECHO) $(TOUCH) $(INST_SCRIPT)$(DFSEP).exists

$(INST_MAN1DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN1DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN1DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN1DIR)$(DFSEP).exists

$(INST_MAN3DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN3DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN3DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN3DIR)$(DFSEP).exists



# --- MakeMaker linkext section:

linkext :: dynamic
	$(NOECHO) $(NOOP)


# --- MakeMaker dlsyms section:


# --- MakeMaker dynamic_bs section:

BOOTSTRAP =


# --- MakeMaker dynamic section:

dynamic :: $(FIRST_MAKEFILE) config $(INST_BOOT) $(INST_DYNAMIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker dynamic_lib section:


# --- MakeMaker static section:

## $(INST_PM) has been moved to the all: target.
## It remains here for awhile to allow for old usage: "make static"
static :: $(FIRST_MAKEFILE) $(INST_STATIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker static_lib section:


# --- MakeMaker manifypods section:

POD2MAN_EXE = $(PERLRUN) "-MExtUtils::Command::MM" -e pod2man "--"
POD2MAN = $(POD2MAN_EXE)


manifypods : pure_all config 
	$(NOECHO) $(NOOP)




# --- MakeMaker processPL section:


# --- MakeMaker installbin section:


# --- MakeMaker subdirs section:

# none

# --- MakeMaker clean_subdirs section:
clean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker clean section:

# Delete temporary files but do not touch installed files. We don't delete
# the Makefile here so a later make realclean still has a makefile to use.

clean :: clean_subdirs
	- $(RM_F) \
	  $(BASEEXT).bso $(BASEEXT).def \
	  $(BASEEXT).exp $(BASEEXT).x \
	  $(BOOTSTRAP) $(INST_ARCHAUTODIR)/extralibs.all \
	  $(INST_ARCHAUTODIR)/extralibs.ld $(MAKE_APERL_FILE) \
	  *$(LIB_EXT) *$(OBJ_EXT) \
	  *perl.core MYMETA.json \
	  MYMETA.yml blibdirs.ts \
	  core core.*perl.*.? \
	  core.[0-9] core.[0-9][0-9] \
	  core.[0-9][0-9][0-9] core.[0-9][0-9][0-9][0-9] \
	  core.[0-9][0-9][0-9][0-9][0-9] lib$(BASEEXT).def \
	  mon.out perl \
	  perl$(EXE_EXT) perl.exe \
	  perlmain.c pm_to_blib \
	  pm_to_blib.ts so_locations \
	  tmon.out 
	- $(RM_RF) \
	  .-* blib 
	  $(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	- $(MV) $(FIRST_MAKEFILE) $(MAKEFILE_OLD) $(DEV_NULL)


# --- MakeMaker realclean_subdirs section:
# so clean is forced to complete before realclean_subdirs runs
realclean_subdirs : clean
	$(NOECHO) $(NOOP)


# --- MakeMaker realclean section:
# Delete temporary files (via clean) and also delete dist files
realclean purge :: realclean_subdirs
	- $(RM_F) \
	  $(FIRST_MAKEFILE) $(MAKEFILE_OLD) 
	- $(RM_RF) \
	  $(DISTVNAME) 


# --- MakeMaker metafile section:
metafile : create_distdir
	$(NOECHO) $(ECHO) Generating META.yml
	$(NOECHO) $(ECHO) '---' > META_new.yml
	$(NOECHO) $(ECHO) 'abstract: lib/GetStateRootHash/GetStateRootHashRPC.pm' >> META_new.yml
	$(NOECHO) $(ECHO) 'author:' >> META_new.yml
	$(NOECHO) $(ECHO) '  - '\''huy <tqhuy2018@gmail.com>'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'build_requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  ExtUtils::MakeMaker: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Test::More: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'configure_requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  ExtUtils::MakeMaker: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'dynamic_config: 1' >> META_new.yml
	$(NOECHO) $(ECHO) 'generated_by: '\''ExtUtils::MakeMaker version 7.34, CPAN::Meta::Converter version 2.150010'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'license: mit' >> META_new.yml
	$(NOECHO) $(ECHO) 'meta-spec:' >> META_new.yml
	$(NOECHO) $(ECHO) '  url: http://module-build.sourceforge.net/META-spec-v1.4.html' >> META_new.yml
	$(NOECHO) $(ECHO) '  version: '\''1.4'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'name: GetStateRootHash-GetStateRootHashRPC' >> META_new.yml
	$(NOECHO) $(ECHO) 'no_index:' >> META_new.yml
	$(NOECHO) $(ECHO) '  directory:' >> META_new.yml
	$(NOECHO) $(ECHO) '    - t' >> META_new.yml
	$(NOECHO) $(ECHO) '    - inc' >> META_new.yml
	$(NOECHO) $(ECHO) 'requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  perl: '\''5.008003'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'version: 0.01' >> META_new.yml
	$(NOECHO) $(ECHO) 'x_serialization_backend: '\''CPAN::Meta::YAML version 0.018'\''' >> META_new.yml
	-$(NOECHO) $(MV) META_new.yml $(DISTVNAME)/META.yml
	$(NOECHO) $(ECHO) Generating META.json
	$(NOECHO) $(ECHO) '{' > META_new.json
	$(NOECHO) $(ECHO) '   "abstract" : "lib/GetStateRootHash/GetStateRootHashRPC.pm",' >> META_new.json
	$(NOECHO) $(ECHO) '   "author" : [' >> META_new.json
	$(NOECHO) $(ECHO) '      "huy <tqhuy2018@gmail.com>"' >> META_new.json
	$(NOECHO) $(ECHO) '   ],' >> META_new.json
	$(NOECHO) $(ECHO) '   "dynamic_config" : 1,' >> META_new.json
	$(NOECHO) $(ECHO) '   "generated_by" : "ExtUtils::MakeMaker version 7.34, CPAN::Meta::Converter version 2.150010",' >> META_new.json
	$(NOECHO) $(ECHO) '   "license" : [' >> META_new.json
	$(NOECHO) $(ECHO) '      "mit"' >> META_new.json
	$(NOECHO) $(ECHO) '   ],' >> META_new.json
	$(NOECHO) $(ECHO) '   "meta-spec" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "url" : "http://search.cpan.org/perldoc?CPAN::Meta::Spec",' >> META_new.json
	$(NOECHO) $(ECHO) '      "version" : 2' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "name" : "GetStateRootHash-GetStateRootHashRPC",' >> META_new.json
	$(NOECHO) $(ECHO) '   "no_index" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "directory" : [' >> META_new.json
	$(NOECHO) $(ECHO) '         "t",' >> META_new.json
	$(NOECHO) $(ECHO) '         "inc"' >> META_new.json
	$(NOECHO) $(ECHO) '      ]' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "prereqs" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "build" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "ExtUtils::MakeMaker" : "0"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      },' >> META_new.json
	$(NOECHO) $(ECHO) '      "configure" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "ExtUtils::MakeMaker" : "0"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      },' >> META_new.json
	$(NOECHO) $(ECHO) '      "runtime" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "perl" : "5.008003"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      },' >> META_new.json
	$(NOECHO) $(ECHO) '      "test" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "Test::More" : "0"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      }' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "release_status" : "stable",' >> META_new.json
	$(NOECHO) $(ECHO) '   "version" : 0.01,' >> META_new.json
	$(NOECHO) $(ECHO) '   "x_serialization_backend" : "JSON::PP version 4.02"' >> META_new.json
	$(NOECHO) $(ECHO) '}' >> META_new.json
	-$(NOECHO) $(MV) META_new.json $(DISTVNAME)/META.json


# --- MakeMaker signature section:
signature :
	cpansign -s


# --- MakeMaker dist_basics section:
distclean :: realclean distcheck
	$(NOECHO) $(NOOP)

distcheck :
	$(PERLRUN) "-MExtUtils::Manifest=fullcheck" -e fullcheck

skipcheck :
	$(PERLRUN) "-MExtUtils::Manifest=skipcheck" -e skipcheck

manifest :
	$(PERLRUN) "-MExtUtils::Manifest=mkmanifest" -e mkmanifest

veryclean : realclean
	$(RM_F) *~ */*~ *.orig */*.orig *.bak */*.bak *.old */*.old



# --- MakeMaker dist_core section:

dist : $(DIST_DEFAULT) $(FIRST_MAKEFILE)
	$(NOECHO) $(ABSPERLRUN) -l -e 'print '\''Warning: Makefile possibly out of date with $(VERSION_FROM)'\''' \
	  -e '    if -e '\''$(VERSION_FROM)'\'' and -M '\''$(VERSION_FROM)'\'' < -M '\''$(FIRST_MAKEFILE)'\'';' --

tardist : $(DISTVNAME).tar$(SUFFIX)
	$(NOECHO) $(NOOP)

uutardist : $(DISTVNAME).tar$(SUFFIX)
	uuencode $(DISTVNAME).tar$(SUFFIX) $(DISTVNAME).tar$(SUFFIX) > $(DISTVNAME).tar$(SUFFIX)_uu
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).tar$(SUFFIX)_uu'

$(DISTVNAME).tar$(SUFFIX) : distdir
	$(PREOP)
	$(TO_UNIX)
	$(TAR) $(TARFLAGS) $(DISTVNAME).tar $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(COMPRESS) $(DISTVNAME).tar
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).tar$(SUFFIX)'
	$(POSTOP)

zipdist : $(DISTVNAME).zip
	$(NOECHO) $(NOOP)

$(DISTVNAME).zip : distdir
	$(PREOP)
	$(ZIP) $(ZIPFLAGS) $(DISTVNAME).zip $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).zip'
	$(POSTOP)

shdist : distdir
	$(PREOP)
	$(SHAR) $(DISTVNAME) > $(DISTVNAME).shar
	$(RM_RF) $(DISTVNAME)
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).shar'
	$(POSTOP)


# --- MakeMaker distdir section:
create_distdir :
	$(RM_RF) $(DISTVNAME)
	$(PERLRUN) "-MExtUtils::Manifest=manicopy,maniread" \
		-e "manicopy(maniread(),'$(DISTVNAME)', '$(DIST_CP)');"

distdir : create_distdir distmeta 
	$(NOECHO) $(NOOP)



# --- MakeMaker dist_test section:
disttest : distdir
	cd $(DISTVNAME) && $(ABSPERLRUN) Makefile.PL 
	cd $(DISTVNAME) && $(MAKE) $(PASTHRU)
	cd $(DISTVNAME) && $(MAKE) test $(PASTHRU)



# --- MakeMaker dist_ci section:
ci :
	$(ABSPERLRUN) -MExtUtils::Manifest=maniread -e '@all = sort keys %{ maniread() };' \
	  -e 'print(qq{Executing $(CI) @all\n});' \
	  -e 'system(qq{$(CI) @all}) == 0 or die $$!;' \
	  -e 'print(qq{Executing $(RCS_LABEL) ...\n});' \
	  -e 'system(qq{$(RCS_LABEL) @all}) == 0 or die $$!;' --


# --- MakeMaker distmeta section:
distmeta : create_distdir metafile
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'exit unless -e q{META.yml};' \
	  -e 'eval { maniadd({q{META.yml} => q{Module YAML meta-data (added by MakeMaker)}}) }' \
	  -e '    or die "Could not add META.yml to MANIFEST: $${'\''@'\''}"' --
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'exit unless -f q{META.json};' \
	  -e 'eval { maniadd({q{META.json} => q{Module JSON meta-data (added by MakeMaker)}}) }' \
	  -e '    or die "Could not add META.json to MANIFEST: $${'\''@'\''}"' --



# --- MakeMaker distsignature section:
distsignature : distmeta
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'eval { maniadd({q{SIGNATURE} => q{Public-key signature (added by MakeMaker)}}) }' \
	  -e '    or die "Could not add SIGNATURE to MANIFEST: $${'\''@'\''}"' --
	$(NOECHO) cd $(DISTVNAME) && $(TOUCH) SIGNATURE
	cd $(DISTVNAME) && cpansign -s



# --- MakeMaker install section:

install :: pure_install doc_install
	$(NOECHO) $(NOOP)

install_perl :: pure_perl_install doc_perl_install
	$(NOECHO) $(NOOP)

install_site :: pure_site_install doc_site_install
	$(NOECHO) $(NOOP)

install_vendor :: pure_vendor_install doc_vendor_install
	$(NOECHO) $(NOOP)

pure_install :: pure_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

doc_install :: doc_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

pure__install : pure_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

doc__install : doc_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

pure_perl_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read "$(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist" \
		write "$(DESTINSTALLARCHLIB)/auto/$(FULLEXT)/.packlist" \
		"$(INST_LIB)" "$(DESTINSTALLPRIVLIB)" \
		"$(INST_ARCHLIB)" "$(DESTINSTALLARCHLIB)" \
		"$(INST_BIN)" "$(DESTINSTALLBIN)" \
		"$(INST_SCRIPT)" "$(DESTINSTALLSCRIPT)" \
		"$(INST_MAN1DIR)" "$(DESTINSTALLMAN1DIR)" \
		"$(INST_MAN3DIR)" "$(DESTINSTALLMAN3DIR)"
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		"$(SITEARCHEXP)/auto/$(FULLEXT)"


pure_site_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read "$(SITEARCHEXP)/auto/$(FULLEXT)/.packlist" \
		write "$(DESTINSTALLSITEARCH)/auto/$(FULLEXT)/.packlist" \
		"$(INST_LIB)" "$(DESTINSTALLSITELIB)" \
		"$(INST_ARCHLIB)" "$(DESTINSTALLSITEARCH)" \
		"$(INST_BIN)" "$(DESTINSTALLSITEBIN)" \
		"$(INST_SCRIPT)" "$(DESTINSTALLSITESCRIPT)" \
		"$(INST_MAN1DIR)" "$(DESTINSTALLSITEMAN1DIR)" \
		"$(INST_MAN3DIR)" "$(DESTINSTALLSITEMAN3DIR)"
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		"$(PERL_ARCHLIB)/auto/$(FULLEXT)"

pure_vendor_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read "$(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist" \
		write "$(DESTINSTALLVENDORARCH)/auto/$(FULLEXT)/.packlist" \
		"$(INST_LIB)" "$(DESTINSTALLVENDORLIB)" \
		"$(INST_ARCHLIB)" "$(DESTINSTALLVENDORARCH)" \
		"$(INST_BIN)" "$(DESTINSTALLVENDORBIN)" \
		"$(INST_SCRIPT)" "$(DESTINSTALLVENDORSCRIPT)" \
		"$(INST_MAN1DIR)" "$(DESTINSTALLVENDORMAN1DIR)" \
		"$(INST_MAN3DIR)" "$(DESTINSTALLVENDORMAN3DIR)"


doc_perl_install :: all
	$(NOECHO) $(ECHO) Appending installation info to "$(DESTINSTALLARCHLIB)/perllocal.pod"
	-$(NOECHO) $(MKPATH) "$(DESTINSTALLARCHLIB)"
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLPRIVLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> "$(DESTINSTALLARCHLIB)/perllocal.pod"

doc_site_install :: all
	$(NOECHO) $(ECHO) Appending installation info to "$(DESTINSTALLARCHLIB)/perllocal.pod"
	-$(NOECHO) $(MKPATH) "$(DESTINSTALLARCHLIB)"
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLSITELIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> "$(DESTINSTALLARCHLIB)/perllocal.pod"

doc_vendor_install :: all
	$(NOECHO) $(ECHO) Appending installation info to "$(DESTINSTALLARCHLIB)/perllocal.pod"
	-$(NOECHO) $(MKPATH) "$(DESTINSTALLARCHLIB)"
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLVENDORLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> "$(DESTINSTALLARCHLIB)/perllocal.pod"


uninstall :: uninstall_from_$(INSTALLDIRS)dirs
	$(NOECHO) $(NOOP)

uninstall_from_perldirs ::
	$(NOECHO) $(UNINSTALL) "$(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist"

uninstall_from_sitedirs ::
	$(NOECHO) $(UNINSTALL) "$(SITEARCHEXP)/auto/$(FULLEXT)/.packlist"

uninstall_from_vendordirs ::
	$(NOECHO) $(UNINSTALL) "$(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist"


# --- MakeMaker force section:
# Phony target to force checking subdirectories.
FORCE :
	$(NOECHO) $(NOOP)


# --- MakeMaker perldepend section:


# --- MakeMaker makefile section:
# We take a very conservative approach here, but it's worth it.
# We move Makefile to Makefile.old here to avoid gnu make looping.
$(FIRST_MAKEFILE) : Makefile.PL $(CONFIGDEP)
	$(NOECHO) $(ECHO) "Makefile out-of-date with respect to $?"
	$(NOECHO) $(ECHO) "Cleaning current config before rebuilding Makefile..."
	-$(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	-$(NOECHO) $(MV)   $(FIRST_MAKEFILE) $(MAKEFILE_OLD)
	- $(MAKE) $(USEMAKEFILE) $(MAKEFILE_OLD) clean $(DEV_NULL)
	$(PERLRUN) Makefile.PL 
	$(NOECHO) $(ECHO) "==> Your Makefile has been rebuilt. <=="
	$(NOECHO) $(ECHO) "==> Please rerun the $(MAKE) command.  <=="
	$(FALSE)



# --- MakeMaker staticmake section:

# --- MakeMaker makeaperl section ---
MAP_TARGET    = perl
FULLPERL      = "/usr/bin/perl"
MAP_PERLINC   = "-Iblib/arch" "-Iblib/lib" "-I/System/Library/Perl/5.30/darwin-thread-multi-2level" "-I/System/Library/Perl/5.30"

$(MAP_TARGET) :: $(MAKE_APERL_FILE)
	$(MAKE) $(USEMAKEFILE) $(MAKE_APERL_FILE) $@

$(MAKE_APERL_FILE) : static $(FIRST_MAKEFILE) pm_to_blib
	$(NOECHO) $(ECHO) Writing \"$(MAKE_APERL_FILE)\" for this $(MAP_TARGET)
	$(NOECHO) $(PERLRUNINST) \
		Makefile.PL DIR="" \
		MAKEFILE=$(MAKE_APERL_FILE) LINKTYPE=static \
		MAKEAPERL=1 NORECURS=1 CCCDLFLAGS=


# --- MakeMaker test section:
TEST_VERBOSE=0
TEST_TYPE=test_$(LINKTYPE)
TEST_FILE = test.pl
TEST_FILES = t/*.t
TESTDB_SW = -d

testdb :: testdb_$(LINKTYPE)
	$(NOECHO) $(NOOP)

test :: $(TEST_TYPE)
	$(NOECHO) $(NOOP)

# Occasionally we may face this degenerate target:
test_ : test_dynamic
	$(NOECHO) $(NOOP)

subdirs-test_dynamic :: dynamic pure_all

test_dynamic :: subdirs-test_dynamic
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness($(TEST_VERBOSE), '$(INST_LIB)', '$(INST_ARCHLIB)')" $(TEST_FILES)

testdb_dynamic :: dynamic pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) $(TESTDB_SW) "-I$(INST_LIB)" "-I$(INST_ARCHLIB)" $(TEST_FILE)

subdirs-test_static :: static pure_all

test_static :: subdirs-test_static
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness($(TEST_VERBOSE), '$(INST_LIB)', '$(INST_ARCHLIB)')" $(TEST_FILES)

testdb_static :: static pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) $(TESTDB_SW) "-I$(INST_LIB)" "-I$(INST_ARCHLIB)" $(TEST_FILE)



# --- MakeMaker ppd section:
# Creates a PPD (Perl Package Description) for a binary distribution.
ppd :
	$(NOECHO) $(ECHO) '<SOFTPKG NAME="GetStateRootHash-GetStateRootHashRPC" VERSION="0.01">' > GetStateRootHash-GetStateRootHashRPC.ppd
	$(NOECHO) $(ECHO) '    <ABSTRACT>lib/GetStateRootHash/GetStateRootHashRPC.pm</ABSTRACT>' >> GetStateRootHash-GetStateRootHashRPC.ppd
	$(NOECHO) $(ECHO) '    <AUTHOR>huy &lt;tqhuy2018@gmail.com&gt;</AUTHOR>' >> GetStateRootHash-GetStateRootHashRPC.ppd
	$(NOECHO) $(ECHO) '    <IMPLEMENTATION>' >> GetStateRootHash-GetStateRootHashRPC.ppd
	$(NOECHO) $(ECHO) '        <PERLCORE VERSION="5,008003,0,0" />' >> GetStateRootHash-GetStateRootHashRPC.ppd
	$(NOECHO) $(ECHO) '        <ARCHITECTURE NAME="darwin-thread-multi-2level-5.30" />' >> GetStateRootHash-GetStateRootHashRPC.ppd
	$(NOECHO) $(ECHO) '        <CODEBASE HREF="" />' >> GetStateRootHash-GetStateRootHashRPC.ppd
	$(NOECHO) $(ECHO) '    </IMPLEMENTATION>' >> GetStateRootHash-GetStateRootHashRPC.ppd
	$(NOECHO) $(ECHO) '</SOFTPKG>' >> GetStateRootHash-GetStateRootHashRPC.ppd


# --- MakeMaker pm_to_blib section:

pm_to_blib : $(FIRST_MAKEFILE) $(TO_INST_PM)
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  'Build.pl' '$(INST_LIB)/GetStateRootHash/Build.pl' \
	  'Makefile.pl' '$(INST_LIB)/GetStateRootHash/Makefile.pl' \
	  'lib/CLValue/CLParse.pm' 'blib/lib/CLValue/CLParse.pm' \
	  'lib/CLValue/CLType.pm' 'blib/lib/CLValue/CLType.pm' \
	  'lib/CLValue/CLValue.pm' 'blib/lib/CLValue/CLValue.pm' \
	  'lib/CasperRPC.pm' 'blib/lib/CasperRPC.pm' \
	  'lib/Common/BlockIdentifier.pm' 'blib/lib/Common/BlockIdentifier.pm' \
	  'lib/Common/ConstValues.pm' 'blib/lib/Common/ConstValues.pm' \
	  'lib/Common/ErrorException.pm' 'blib/lib/Common/ErrorException.pm' \
	  'lib/GetAuction/AuctionState.pm' 'blib/lib/GetAuction/AuctionState.pm' \
	  'lib/GetAuction/GetAuctionInfoRPC.pm' 'blib/lib/GetAuction/GetAuctionInfoRPC.pm' \
	  'lib/GetAuction/GetAuctionInfoResult.pm' 'blib/lib/GetAuction/GetAuctionInfoResult.pm' \
	  'lib/GetAuction/JsonBid.pm' 'blib/lib/GetAuction/JsonBid.pm' \
	  'lib/GetAuction/JsonBids.pm' 'blib/lib/GetAuction/JsonBids.pm' \
	  'lib/GetAuction/JsonDelegator.pm' 'blib/lib/GetAuction/JsonDelegator.pm' \
	  'lib/GetAuction/JsonEraValidators.pm' 'blib/lib/GetAuction/JsonEraValidators.pm' \
	  'lib/GetAuction/JsonValidatorWeights.pm' 'blib/lib/GetAuction/JsonValidatorWeights.pm' \
	  'lib/GetBalance/GetBalanceParams.pm' 'blib/lib/GetBalance/GetBalanceParams.pm' \
	  'lib/GetBalance/GetBalanceResult.pm' 'blib/lib/GetBalance/GetBalanceResult.pm' \
	  'lib/GetBalance/GetBalanceResultRPC.pm' 'blib/lib/GetBalance/GetBalanceResultRPC.pm' \
	  'lib/GetBlock/GetBlockRPC.pm' 'blib/lib/GetBlock/GetBlockRPC.pm' \
	  'lib/GetBlock/GetBlockResult.pm' 'blib/lib/GetBlock/GetBlockResult.pm' \
	  'lib/GetBlock/JsonBlock.pm' 'blib/lib/GetBlock/JsonBlock.pm' \
	  'lib/GetBlock/JsonBlockBody.pm' 'blib/lib/GetBlock/JsonBlockBody.pm' \
	  'lib/GetBlock/JsonBlockHeader.pm' 'blib/lib/GetBlock/JsonBlockHeader.pm' \
	  'lib/GetBlock/JsonEraEnd.pm' 'blib/lib/GetBlock/JsonEraEnd.pm' \
	  'lib/GetBlock/JsonEraReport.pm' 'blib/lib/GetBlock/JsonEraReport.pm' \
	  'lib/GetBlock/JsonProof.pm' 'blib/lib/GetBlock/JsonProof.pm' \
	  'lib/GetBlock/Reward.pm' 'blib/lib/GetBlock/Reward.pm' \
	  'lib/GetBlock/ValidatorWeight.pm' 'blib/lib/GetBlock/ValidatorWeight.pm' \
	  'lib/GetBlockTransfers/GetBlockTransfersRPC.pm' 'blib/lib/GetBlockTransfers/GetBlockTransfersRPC.pm' \
	  'lib/GetBlockTransfers/GetBlockTransfersResult.pm' 'blib/lib/GetBlockTransfers/GetBlockTransfersResult.pm' \
	  'lib/GetDeploy/Approval.pm' 'blib/lib/GetDeploy/Approval.pm' \
	  'lib/GetDeploy/Deploy.pm' 'blib/lib/GetDeploy/Deploy.pm' \
	  'lib/GetDeploy/DeployHeader.pm' 'blib/lib/GetDeploy/DeployHeader.pm' \
	  'lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem.pm' 'blib/lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem.pm' \
	  'lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem_ModuleBytes.pm' 'blib/lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem_ModuleBytes.pm' \
	  'lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem_StoredContractByHash.pm' 'blib/lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem_StoredContractByHash.pm' \
	  'lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem_StoredContractByName.pm' 'blib/lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem_StoredContractByName.pm' \
	  'lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem_StoredVersionedContractByHash.pm' 'blib/lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem_StoredVersionedContractByHash.pm' \
	  'lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem_StoredVersionedContractByName.pm' 'blib/lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem_StoredVersionedContractByName.pm' \
	  'lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem_Transfer.pm' 'blib/lib/GetDeploy/ExecutableDeployItem/ExecutableDeployItem_Transfer.pm' \
	  'lib/GetDeploy/ExecutableDeployItem/NamedArg.pm' 'blib/lib/GetDeploy/ExecutableDeployItem/NamedArg.pm' \
	  'lib/GetDeploy/ExecutableDeployItem/RuntimeArgs.pm' 'blib/lib/GetDeploy/ExecutableDeployItem/RuntimeArgs.pm' \
	  'lib/GetDeploy/ExecutionResult/CasperOperation.pm' 'blib/lib/GetDeploy/ExecutionResult/CasperOperation.pm' \
	  'lib/GetDeploy/ExecutionResult/CasperTransform.pm' 'blib/lib/GetDeploy/ExecutionResult/CasperTransform.pm' \
	  'lib/GetDeploy/ExecutionResult/ExecutionEffect.pm' 'blib/lib/GetDeploy/ExecutionResult/ExecutionEffect.pm' \
	  'lib/GetDeploy/ExecutionResult/ExecutionResult.pm' 'blib/lib/GetDeploy/ExecutionResult/ExecutionResult.pm' \
	  'lib/GetDeploy/ExecutionResult/JsonExecutionResult.pm' 'blib/lib/GetDeploy/ExecutionResult/JsonExecutionResult.pm' \
	  'lib/GetDeploy/ExecutionResult/Transform/Bid.pm' 'blib/lib/GetDeploy/ExecutionResult/Transform/Bid.pm' \
	  'lib/GetDeploy/ExecutionResult/Transform/CasperTransfer.pm' 'blib/lib/GetDeploy/ExecutionResult/Transform/CasperTransfer.pm' \
	  'lib/GetDeploy/ExecutionResult/Transform/Delegator.pm' 'blib/lib/GetDeploy/ExecutionResult/Transform/Delegator.pm' \
	  'lib/GetDeploy/ExecutionResult/Transform/DeployInfo.pm' 'blib/lib/GetDeploy/ExecutionResult/Transform/DeployInfo.pm' \
	  'lib/GetDeploy/ExecutionResult/Transform/EraInfo.pm' 'blib/lib/GetDeploy/ExecutionResult/Transform/EraInfo.pm' \
	  'lib/GetDeploy/ExecutionResult/Transform/NamedKey.pm' 'blib/lib/GetDeploy/ExecutionResult/Transform/NamedKey.pm' \
	  'lib/GetDeploy/ExecutionResult/Transform/SeigniorageAllocation.pm' 'blib/lib/GetDeploy/ExecutionResult/Transform/SeigniorageAllocation.pm' \
	  'lib/GetDeploy/ExecutionResult/Transform/UnbondingPurse.pm' 'blib/lib/GetDeploy/ExecutionResult/Transform/UnbondingPurse.pm' \
	  'lib/GetDeploy/ExecutionResult/Transform/VestingSchedule.pm' 'blib/lib/GetDeploy/ExecutionResult/Transform/VestingSchedule.pm' \
	  'lib/GetDeploy/ExecutionResult/Transform/Withdraw.pm' 'blib/lib/GetDeploy/ExecutionResult/Transform/Withdraw.pm' \
	  'lib/GetDeploy/ExecutionResult/TransformEntry.pm' 'blib/lib/GetDeploy/ExecutionResult/TransformEntry.pm' \
	  'lib/GetDeploy/GetDeployParams.pm' 'blib/lib/GetDeploy/GetDeployParams.pm' \
	  'lib/GetDeploy/GetDeployRPC.pm' 'blib/lib/GetDeploy/GetDeployRPC.pm' \
	  'lib/GetDeploy/GetDeployResult.pm' 'blib/lib/GetDeploy/GetDeployResult.pm' \
	  'lib/GetDictionaryItem/DIAccountNamedKey.pm' 'blib/lib/GetDictionaryItem/DIAccountNamedKey.pm' \
	  'lib/GetDictionaryItem/DIContractNamedKey.pm' 'blib/lib/GetDictionaryItem/DIContractNamedKey.pm' \
	  'lib/GetDictionaryItem/DIDictionary.pm' 'blib/lib/GetDictionaryItem/DIDictionary.pm' \
	  'lib/GetDictionaryItem/DIURef.pm' 'blib/lib/GetDictionaryItem/DIURef.pm' \
	  'lib/GetDictionaryItem/DictionaryIdentifier.pm' 'blib/lib/GetDictionaryItem/DictionaryIdentifier.pm' \
	  'lib/GetDictionaryItem/GetDictionaryItemParams.pm' 'blib/lib/GetDictionaryItem/GetDictionaryItemParams.pm' \
	  'lib/GetDictionaryItem/GetDictionaryItemRPC.pm' 'blib/lib/GetDictionaryItem/GetDictionaryItemRPC.pm' \
	  'lib/GetDictionaryItem/GetDictionaryItemResult.pm' 'blib/lib/GetDictionaryItem/GetDictionaryItemResult.pm' \
	  'lib/GetEraInfoBySwitchBlock/EraSummary.pm' 'blib/lib/GetEraInfoBySwitchBlock/EraSummary.pm' \
	  'lib/GetEraInfoBySwitchBlock/GetEraInfoBySwitchBlockRPC.pm' 'blib/lib/GetEraInfoBySwitchBlock/GetEraInfoBySwitchBlockRPC.pm' \
	  'lib/GetEraInfoBySwitchBlock/GetEraInfoResult.pm' 'blib/lib/GetEraInfoBySwitchBlock/GetEraInfoResult.pm' \
	  'lib/GetItem/GetItemParams.pm' 'blib/lib/GetItem/GetItemParams.pm' \
	  'lib/GetItem/GetItemRPC.pm' 'blib/lib/GetItem/GetItemRPC.pm' \
	  'lib/GetItem/GetItemResult.pm' 'blib/lib/GetItem/GetItemResult.pm' \
	  'lib/GetPeers/GetPeerRPC.pm' 'blib/lib/GetPeers/GetPeerRPC.pm' \
	  'lib/GetPeers/GetPeersResult.pm' 'blib/lib/GetPeers/GetPeersResult.pm' \
	  'lib/GetPeers/PeerEntry.pm' 'blib/lib/GetPeers/PeerEntry.pm' \
	  'lib/GetStateRootHash/GetStateRootHashRPC.pm' 'blib/lib/GetStateRootHash/GetStateRootHashRPC.pm' \
	  'lib/GetStatus/GetStatusRPC.pm' 'blib/lib/GetStatus/GetStatusRPC.pm' \
	  'lib/GetStatus/GetStatusResult.pm' 'blib/lib/GetStatus/GetStatusResult.pm' \
	  'lib/GetStatus/MinimalBlockInfo.pm' 'blib/lib/GetStatus/MinimalBlockInfo.pm' \
	  'lib/GetStatus/NextUpgrade.pm' 'blib/lib/GetStatus/NextUpgrade.pm' \
	  'lib/StoredValue/Account.pm' 'blib/lib/StoredValue/Account.pm' \
	  'lib/StoredValue/ActionThresholds.pm' 'blib/lib/StoredValue/ActionThresholds.pm' \
	  'lib/StoredValue/AssociatedKey.pm' 'blib/lib/StoredValue/AssociatedKey.pm' \
	  'lib/StoredValue/CasperContract.pm' 'blib/lib/StoredValue/CasperContract.pm' \
	  'lib/StoredValue/ContractPackage.pm' 'blib/lib/StoredValue/ContractPackage.pm' \
	  'lib/StoredValue/ContractVersion.pm' 'blib/lib/StoredValue/ContractVersion.pm' \
	  'lib/StoredValue/DisabledVersion.pm' 'blib/lib/StoredValue/DisabledVersion.pm' \
	  'lib/StoredValue/EntryPoint.pm' 'blib/lib/StoredValue/EntryPoint.pm' \
	  'lib/StoredValue/EntryPointAccess.pm' 'blib/lib/StoredValue/EntryPointAccess.pm' \
	  'lib/StoredValue/Groups.pm' 'blib/lib/StoredValue/Groups.pm' \
	  'lib/StoredValue/Parameter.pm' 'blib/lib/StoredValue/Parameter.pm' \
	  'lib/StoredValue/StoredValue.pm' 'blib/lib/StoredValue/StoredValue.pm' 
	$(NOECHO) $(TOUCH) pm_to_blib


# --- MakeMaker selfdocument section:

# here so even if top_targets is overridden, these will still be defined
# gmake will silently still work if any are .PHONY-ed but nmake won't

static ::
	$(NOECHO) $(NOOP)

dynamic ::
	$(NOECHO) $(NOOP)

config ::
	$(NOECHO) $(NOOP)


# --- MakeMaker postamble section:


# End.
