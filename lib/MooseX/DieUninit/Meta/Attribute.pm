package MooseX::DieUninit::Meta::Attribute;
use Moose::Role;
use MooseX::DieUninit::Exception;

before get_value => sub {
    my ($self, $instance, $for_trigger) = @_;

    return if $self->is_lazy;
    if (not $self->has_value($instance)) {
        die MooseX::DieUninit::Exception->new({
            instance => $instance,
            attribute => $self,
        });
    }
};

around _inline_get_value => sub {
    my ($orig, $self, $instance, @etc) = @_;

    my @code = $self->$orig($instance,@etc);
    return @code if $self->is_lazy;

    my $has_value = $self->_inline_instance_has($instance);
    my $throw = q[die Module::Runtime::use_module("MooseX::DieUninit::Exception")->new(] .
        'instance => '.$instance.', '.
        'attribute_name => q{'.$self->name.'}, '.
        ');';

    return qq[if (not $has_value) {$throw};],
        @code;
};

1;
