package CGI::Application::Plugin::DevPopup::Params;

# $Id: Params.pm 13 2009-12-04 11:16:01Z stro $

use strict;
use warnings;

use base qw/Exporter/;
use Data::Dumper;

our $VERSION = '1.00';

sub import {
    my $c = scalar caller;
    $c->add_callback( 'devpopup_report', \&_param_report );
    goto &Exporter::import;
}

sub _param_report {
    my $self = shift;
    my $cgi = _cgi_report($self);

    return $self->devpopup->add_report(
        'title'   => 'CGIApp params',
        'summary' => 'CGI::Application parameters',
        'report'  => qq!<style type="text/css">tr.even{background-color:#eee}</style><table><thead><th colspan="2">Parameters</th></thead><tbody> $cgi </tbody></table>!,
    );
}


sub _cgi_report {
    my $self = shift;

    my $r=0;
    my $q = $self;
    my $report = '';
    my $param;

    $report = '<tr><th>param</th><th>value</th></tr>' .
        join ($/, map {
                    $r=1-$r;
                    $param = Data::Dumper->Dump([$q->param($_)]);
                    $param = substr($param, 7, length($param) - 9);
                    qq{<tr class="@{[$r?'odd':'even']}"><td valign="top"> $_ </td><td> @{ [$param] } </td></tr>}
                 } grep { not /^__CAP_DEVPOPUP/x } sort $q->param());
    return $report;
}

1; 

=head1 NAME

CGI::Application::Plugin::DevPopup::Params - show CGI::Application parameters in DevPopup window

=head1 SYNOPSIS

    use CGI::Application::Plugin::DevPopup;
    use CGI::Application::Plugin::DevPopup::Params;

    The rest of your application follows
    ...

=head1 VERSION

1.00

=head1 SEE ALSO

L<CGI::Application::Plugin::DevPopup>, L<CGI::Application>

=head1 INCOMPATIBILITIES

Not known.

=head1 BUGS AND LIMITATIONS

Not known.

=head1 AUTHOR

Serguei Trouchelle, L<stro@cpan.org>

Most of code is based by CGI::Application::Plugin::DevPopup by Rhesa Rozendaal, L<rhesa@cpan.org>

=head1 LICENSE AND COPYRIGHT

This module is distributed under the same terms as Perl itself.

Copyright (c) 2009 Serguei Trouchelle

=cut

