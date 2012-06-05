package Plack::Middleware::Warn::txt;
use strict;
use warnings;
use utf8;
use parent qw/Plack::Middleware/;
use Encode ();
use Plack::Util::Accessor qw/author url/;
our $VERSION = '0.01';

sub call {
    my ($self, $env) = @_;

    if ($env->{PATH_INFO} =~ m!^/warn\.txt$!) {
        my $author = defined $self->author ? $self->author : '2ch';
        my $body = <<"...";
第3者に迷惑をかけ謝罪しない人物に${author}の著作物を使われることは、不利益が大きいため、下記のURLにおける${author}の著作物の利用を禁止します。
また、本人及び関係者による類似サイトへの著作物の利用も同様に禁止します。

@{[ join "\n", @{$self->url || []} ]}



発言の捏造、転載元が明記されていない著作物の利用に関しても、なんらかの措置をとる可能性があります。
...
        return [
            200,
            ['Content-Type' => 'text/plain; charset=utf-8'],
            [Encode::encode_utf8($body)]
        ];
    } else {
        return $self->app->($env);
    }
}

1;
__END__

=head1 NAME

Plack::Middleware::Warn::txt - Yet anther /warn.txt

=head1 SYNOPSIS

  use Plack::Builder;

  builder {
    enable 'Plack::Middleware::Warn::txt',
        author => '2ch',
        url => [
            qw(
                http://yaraon.blog109.fc2.com/
                http://hamusoku.com/
                http://blog.esuteru.com/
                http://jin115.com/
                http://blog.livedoor.jp/insidears/
            )
        ],
  };

=head1 DESCRIPTION

cf. http://2ch.net/warn.txt

=head1 AUTHOR

Takumi Akiyama E<lt>t.akiym at gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
