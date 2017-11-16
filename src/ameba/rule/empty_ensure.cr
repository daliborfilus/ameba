module Ameba::Rule
  # A rule that disallows empty ensure statement.
  #
  # For example, this is considered invalid:
  #
  # ```
  # def some_method
  #   do_some_stuff
  # ensure
  # end
  #
  # begin
  #   do_some_stuff
  # ensure
  # end
  # ```
  #
  # And it should be written as this:
  #
  #
  # ```
  # def some_method
  #   do_some_stuff
  # ensure
  #   do_something_else
  # end
  #
  # begin
  #   do_some_stuff
  # ensure
  #   do_something_else
  # end
  # ```
  #
  struct EmptyEnsure < Base
    def test(source)
      AST::Visitor.new self, source
    end

    def test(source, node : Crystal::ExceptionHandler)
      node_ensure = node.ensure
      return if node_ensure.nil? || !node_ensure.nop?

      source.error self, node.location, "Empty `ensure` block detected"
    end
  end
end
