module Ameba::Rule
  # A rule that reports unused arguments.
  # For example, this is considered invalid:
  #
  # ```
  # def method(a, b, c)
  #   a + b
  # end
  # ```
  # and should be written as:
  #
  # ```
  # def method(a, b)
  #   a + b
  # end
  # ```
  #
  # YAML configuration example:
  #
  # ```
  # UnusedArgument:
  #   Enabled: true
  #   IgnoreDefs: true
  #   IgnoreBlocks: false
  #   IgnoreProcs: false
  # ```
  #
  struct UnusedArgument < Base
    properties do
      description "Disallows unused arguments"

      ignore_defs true
      ignore_blocks false
      ignore_procs false
    end

    MSG = "Unused argument `%s`"

    def test(source)
      AST::ScopeVisitor.new self, source
    end

    def test(source, node : Crystal::ProcLiteral, scope : AST::Scope)
      ignore_procs || find_unused_arguments source, scope
    end

    def test(source, node : Crystal::Block, scope : AST::Scope)
      ignore_blocks || find_unused_arguments source, scope
    end

    def test(source, node : Crystal::Def, scope : AST::Scope)
      ignore_defs || find_unused_arguments source, scope
    end

    private def find_unused_arguments(source, scope)
      scope.arguments.each do |argument|
        next if argument.ignored? || scope.references?(argument.variable)

        source.error self, argument.location, MSG % argument.name
      end
    end
  end
end
