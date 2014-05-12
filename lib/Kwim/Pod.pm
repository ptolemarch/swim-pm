use strict;
package Kwim::Pod;
use base 'Kwim::Markup';

use XXX -with => 'YAML::XS';

use constant top_block_separator => "\n";

sub render_text {
    my ($self, $text) = @_;
    $text =~ s/\n/ /g;
    return $text;
}

sub render_comment {
    my ($self, $node) = @_;
    if ($node !~ /\n/) {
        "=for comment $node\n";
    }
    elsif ($node !~ /\n\n/) {
        "=for comment\n$node\n";
    }
    else {
        "=begin comment\n$node\n=end\n";
    }
}

sub render_para {
    my ($self, $node) = @_;
    my $out = $self->render($node);
    return "$out\n";
}

sub render_blank { '' }

sub render_title {
    my ($self, $node, $number) = @_;
    my ($name, $text) = ref $node ? @$node : (undef, $node);
    if (defined $text) {
        "=head1 Name\n\n$name - $text\n";
    }
    else {
        "=head1 $name\n";
    }
}

sub render_head {
    my ($self, $node, $number) = @_;
    my $out = $self->render($node);
    "=head$number $out\n";
}

sub render_pref {
    my ($self, $node) = @_;
    my $out = $node;
    chomp $out;
    $out =~ s/^/    /gm;
    return "$out\n";
}

sub render_bold {
    my ($self, $node) = @_;
    my $out = $self->render($node);
    return "B<$out>";
}

sub render_emph {
    my ($self, $node) = @_;
    my $out = $self->render($node);
    return "I<$out>";
}

sub render_code {
    my ($self, $node) = @_;
    my $out = $self->render($node);
    return "C<$out>";
}

sub render_hyper {
    my ($self, $node) = @_;
    my ($link, $text) = @{$node}{qw(link text)};
    (length $text == 0)
    ? "L<$link>"
    : "L<$text|$link>";
}

sub render_link {
    my ($self, $node) = @_;
    my ($link, $text) = @{$node}{qw(link text)};
    (length $text == 0)
    ? "L<$link>"
    : "L<$text|$link>";
}

sub render_list {
    my ($self, $node) = @_;
    my $out = $self->render($node);
    "=over\n\n$out=back\n";
}

sub render_item {
    my ($self, $node) = @_;
    my $item = shift @$node;
    my $out = "=item * " . $self->render($item) . "\n\n";
    $out .= $self->render($node) . "\n" if @$node;
    $out;
}

1;
