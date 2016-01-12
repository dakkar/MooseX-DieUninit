From #moose:

> **JLMARTIN** Hi! When using Moose, most of my bugs (mostly strange
> behaviour that gets detected at testing time, but takes a while to
> detect) is caused by leaving out a `lazy => 1` on an attribute. I
> was thinking of a way to help me detect this type of bug earlier (or
> at least easier). Has anyone had his issue, and solved it already?
> Any suggestions?
>
> **JLMARTIN** I know there is a module to make all your attributes
> lazy, but that seemed overkill. I was thinking of a `Perl::Critic`
> module that looks for default/builders, and tries to detect if
> something is done with (`@_`, `$_[...]`, `shift`), to warn that the
> attribute seems to need lazy active. Before starting with that, I
> would like to know if there is something better
>
> **dakkar** JLMARTIN: so your problem is that you have attributes
> whose initialisation depends on other attributes, and when you
> forget to make them lazy, you get unexpected undefs
>
> **JLMARTIN** dakkar: yes
>
> **dakkar** writing a Critic policy is very tricky
>
> **dakkar** maybe an attribute metaclass that dies when you access an
> unitialised attribute?
>
> **dakkar** then you can just construct your object once and check
> that it didn't die

Hence this module. Look at [the test](t/basic.t) to see how to use it.

Later, still in #moose:

> **mst** [p3rl.org/MooseX::LazyRequire](http://p3rl.org/MooseX::LazyRequire)
>
> **mst** a meta-something that added lazy_required to all attributes
> by default or whatever would be neat
>
> **dakkar** hmm. my implementation is quite a bit more convoluted
> than just having a default that dies
>
> **dakkar** ooh, also it fails when it shouldn't
>
> **dakkar** because attributes are initialised at random, not "first
> from init_args, then from defaults"
>
> **dakkar** so no, my thing does not work :)

Maybe I should just write a "`LazyRequire` everywhere" metaclass.
