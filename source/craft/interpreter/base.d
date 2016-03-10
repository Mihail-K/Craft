
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
    override CraftObject *visit(AccessNode node)
    {
        // Access a 'member' (0-argument function call).
        auto left = node.node.accept!(CraftObject *)(this);
        auto name = node.member.token.text;

        return left.invoke(name);
    }

    override CraftObject *visit(AdditionNode node)
    {
        auto value = node.nodes.front.accept!(CraftObject *)(this);

        foreach(operator, operand; node.operators.lockstep(node.nodes.dropOne))
        {
            auto other = operand.accept!(CraftObject *)(this);

            switch(operator.rule)
            {
                case "OpPlus":
                    value = value.opAdd(other);
                    break;

                case "OpMinus":
                    value = value.opSub(other);
                    break;

                default:
                    assert(0);
            }
        }

        return value;
    }

    override CraftObject *visit(BitwiseNode node)
    {
        auto value = node.nodes.front.accept!(CraftObject *)(this);

        foreach(operator, operand; node.operators.lockstep(node.nodes.dropOne))
        {
            auto other = operand.accept!(CraftObject *)(this);

            switch(operator.rule)
            {
                case "OpBitAnd":
                    value = value.opBitAnd(other);
                    break;

                case "OpBitOr":
                    value = value.opBitOr(other);
                    break;

                case "OpBitXor":
                    value = value.opBitXor(other);
                    break;

                default:
                    assert(0);
            }
        }

        return value;
    }

    override CraftObject *visit(BooleanNode node)
    {
        return createBoolean(node.token.text.to!bool);
    }

    override CraftObject *visit(EqualityNode node)
    {
        auto value = node.nodes.front.accept!(CraftObject *)(this);

        foreach(operator, operand; node.operators.lockstep(node.nodes.dropOne))
        {
            auto other = operand.accept!(CraftObject *)(this);

            switch(operator.rule)
            {
                case "OpEquals":
                    value = value.opEqual(other);
                    break;

                case "OpNotEquals":
                    value = value.opNotEqual(other);
                    break;

                default:
                    assert(0);
            }
        }

        return value;
    }

    override CraftObject *visit(IntegerNode node)
    {
        return createInteger(node.token.text.to!long);
    }

    override CraftObject *visit(InvokeNode node)
    {
        // Check for memeber access.
        auto access = cast(AccessNode) node.node;

        if(access !is null)
        {
            // Call a method as a member of a construct.
            auto left = access.node.accept!(CraftObject *)(this);
            auto name = access.member.token.text;
            auto args = node.args.nodes.map!(n => n.accept!(CraftObject *)(this)).array;

            return left.invoke(name, Arguments(args));
        }
        else
        {
            auto left = node.node.accept!(CraftObject *)(this);
            auto args = node.args.nodes.map!(n => n.accept!(CraftObject *)(this)).array;

            return left.invoke("invoke", Arguments(args));
        }
    }

    override CraftObject *visit(LogicalNode node)
    {
        auto value = node.nodes.front.accept!(CraftObject *)(this);

        foreach(operator, operand; node.operators.lockstep(node.nodes.dropOne))
        {
            auto other = operand.accept!(CraftObject *)(this);

            switch(operator.rule)
            {
                case "OpLogicalAnd":
                    value = value.opLogicalAnd(other);
                    break;

                case "OpLogicalOr":
                    value = value.opLogicalOr(other);
                    break;

                default:
                    assert(0);
            }
        }

        return value;
    }

    override CraftObject *visit(MultiplicationNode node)
    {
        auto value = node.nodes.front.accept!(CraftObject *)(this);

        foreach(operator, operand; node.operators.lockstep(node.nodes.dropOne))
        {
            auto other = operand.accept!(CraftObject *)(this);

            switch(operator.rule)
            {
                case "OpTimes":
                    value = value.opTimes(other);
                    break;

                case "OpDivide":
                    value = value.opDivide(other);
                    break;

                case "OpModulo":
                    value = value.opModulo(other);
                    break;

                default:
                    assert(0);
            }
        }

        return value;
    }

    override CraftObject *visit(NullNode node)
    {
        return &NULL;
    }

    override CraftObject *visit(PrefixNode node)
    {
        auto value = node.node.accept!(CraftObject *)(this);

        switch(node.operator.rule)
        {
            case "OpPlus":
                return value.opPlus;

            case "OpMinus":
                return value.opMinus;

            case "OpTilde":
                return value.opComplement;

            case "OpBang":
                return value.opNegate;

            default:
                assert(0);
        }
    }

    override CraftObject *visit(RelationNode node)
    {
        auto value = node.nodes.front.accept!(CraftObject *)(this);

        foreach(operator, operand; node.operators.lockstep(node.nodes.dropOne))
        {
            auto other = operand.accept!(CraftObject *)(this);

            switch(operator.rule)
            {
                case "OpLess":
                    value = value.opLess(other);
                    break;

                case "OpLessEquals":
                    value = value.opLessOrEqual(other);
                    break;

                case "OpGreater":
                    value = value.opGreater(other);
                    break;

                case "OpGreaterEquals":
                    value = value.opGreaterOrEqual(other);
                    break;

                case "KeyIs":
                    value = value.opIs(other);
                    break;

                case "KeyNot":
                    value = value.opIsNot(other);
                    break;

                default:
                    assert(0);
            }
        }

        return value;
    }

    override CraftObject *visit(StartNode node)
    {
        return node.nodes
            .map!(n => n.accept!(CraftObject *)(this))
            .retro
            .front;
    }

    override CraftObject *visit(StringNode node)
    {
        return createString(node.token.text[1 .. $ - 1]);
    }
}
