# Dist::Zilla::Plugin::MakeMaker::Awesome 0.38.
# Don't edit it but the dist.ini and plugins used to construct it.

use strict;
use warnings;

use 5.006;
use ExtUtils::MakeMaker;

sub ConfigureNSS {
  unless (eval { require PkgConfig }) {
    die "PkgConfig package not found, but required to find NSS library";
  }
  my $nss_config = PkgConfig->find('nss');
  if ($nss_config->errmsg) {
    die "To build this module you need NSS installed!";
  }
  return {CCFLAGS => join(' ',$nss_config->get_cflags), LIBS => [ join(' ',$nss_config->get_ldflags) ] };
}

my %WriteMakefileArgs = (
  "ABSTRACT" => "Perl bindings to NSS Mozilla security library",
  "AUTHOR" => "Vladimir Timofeev <vovkasm\@gmail.com>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0,
    "PkgConfig" => "0.14026"
  },
  "DISTNAME" => "Panda-NSS",
  "LICENSE" => "perl",
  "MIN_PERL_VERSION" => "5.006",
  "NAME" => "Panda::NSS",
  "PREREQ_PM" => {
    "XSLoader" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0,
    "File::Spec" => 0,
    "File::Temp" => 0,
    "Test::More" => 0,
    "Test::SharedFork" => 0
  },
  "VERSION" => "0.005",
  "test" => {
    "TESTS" => "t/*.t"
  }
);

%WriteMakefileArgs = (
    %WriteMakefileArgs,
    CONFIGURE => \&ConfigureNSS,
);

my %FallbackPrereqs = (
  "ExtUtils::MakeMaker" => 0,
  "File::Spec" => 0,
  "File::Temp" => 0,
  "Test::More" => 0,
  "Test::SharedFork" => 0,
  "XSLoader" => 0,
  "strict" => 0,
  "warnings" => 0
);

unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
