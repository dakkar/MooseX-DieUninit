package MooseX::DieUninit::Exception;
use Moose;
extends 'Moose::Exception';
with 'Moose::Exception::Role::Instance',
    'Moose::Exception::Role::EitherAttributeOrAttributeName';

sub _build_message {
    my $self = shift;
    "Tried to access attribute "
    . $self->attribute_name . " before initializing it";
}

1;
