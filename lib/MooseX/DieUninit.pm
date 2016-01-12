package MooseX::DieUninit;
use Moose::Exporter;

Moose::Exporter->setup_import_methods(
    class_metaroles => {
        attribute => ['MooseX::DieUninit::Meta::Attribute'],
    },
);

1;
