
module craft.interpreter.base;

import craft.ast;
import craft.lexer;
import craft.parser;
import craft.types;

import std.algorithm;
import std.conv;
import std.range;

class Interpreter : NullVisitor
{
    override CraftObject visit(AdditionNode node)
    {
        auto value = node.nodes.front.accept!(CraftObject)(this);

        foreach(operator, operand; node.operators.lockstep(node.nodes.dropOne))
        {
            auto other = operand.accept!(CraftObject)(this);

            switch(operator.text)
            {
                case "+": // OpPlus
                    value = value.opPlus(other);
                    break;

                case "-": // OpMinus
                    value = value.opMinus(other);
                    break;

                default:
                    assert(0);
            }
        }

        return value;
    }

    override CraftObject visit(IntegerNode node)
    {
        auto value = node.token.text;

        return new CraftInteger(value.to!long);
    }

    override CraftObject visit(MultiplicationNode node)
    {
        auto value = node.nodes.front.accept!(CraftObject)(this);

        foreach(operator, operand; node.operators.lockstep(node.nodes.dropOne))
        {
            auto other = operand.accept!(CraftObject)(this);

            switch(operator.text)
            {
                case "*": // OpTimes
                    value = value.opTimes(other);
                    break;

                case "/": // OpDivide
                    value = value.opDivide(other);
                    break;

                case "%": // OpModulo
                    value = value.opModulo(other);
                    break;

                default:
                    assert(0);
            }
        }

        return value;
    }

    override CraftObject visit(PrefixNode node)
    {
        auto value = node.node.accept!(CraftObject)(this);

        switch(node.operator.text)
        {
            case "+": // OpPlus
                return value.opPlus;

            case "-": // OpMinus
                return value.opMinus;

            case "~": // OpTilde
                return value.opComplement;

            case "!": // OpBang
                return value.opNegate;

            default:
                assert(0);
        }
    }

    override CraftObject visit(StartNode node)
    {
        return node.nodes
            .map!(n => n.accept!(CraftObject)(this))
            .retro
            .front;
    }
}
