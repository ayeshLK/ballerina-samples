import ballerina/regex;

type Expression record {|
    float firstOperand;
    Expression|float secondOperand;
    Operator operator;
|};

function calculate(Expression ex) returns float|error {
    Expression|float secondValue = ex.secondOperand;
    if secondValue is float {
        return ex.operator(ex.firstOperand, secondValue);
    }
    float accumulatedValue = check calculate(secondValue);
    return ex.operator(ex.firstOperand, accumulatedValue);
}

const string baseExpressionRegex = "(\\d+[.\\d]*)(([-+*/](\\d+[.\\d]*)))+";
const string operatorSplittingRegex = "[0-9]+";
const string operandSplittingRegex = "[-+*/]+";

function generate(string literalExpression) returns Expression|error {
    string trimmedExpression = literalExpression.trim();
    if !regex:matches(trimmedExpression, baseExpressionRegex) {
        return error("invalid expression received: expression contains illegal characters");
    }
    float[] operands = [];
    foreach string operandLiteral in regex:split(trimmedExpression, operandSplittingRegex) {
        float operand = check mapToFloat(operandLiteral.trim());
        operands.push(operand);
    }
    Operator[] operators = [];
    foreach string opLiteral in regex:split(trimmedExpression, operatorSplittingRegex) {
        if opLiteral == "" {
            continue;
        }
        Operator op = check mapToOperator(opLiteral.trim());
        operators.push(op);
    }
    if operators.length() != operands.length() - 1 {
        return error("invalid expression received: operator at the end of the expression");
    }
    return generateExpression(operands, operators);
}

function mapToOperator(string operator) returns Operator|error {
    match operator.trim() {
        "+" => {
            return add;
        }
        "-" => {
            return substract;
        }
        "*" => {
            return multiply;
        }
        "/" => {
            return divide;
        }
        _ => {
            return error(string `unknown operator: ${operator}`);
        }
    }
}

function mapToFloat(string operand) returns float|error {
    return float:fromString(operand);
}

function generateExpression(float[] operands, Operator[] operators) returns Expression|error {
    if operands.length() <= 0 {
        return error("invalid expression received: no operands found");
    } else if operands.length() == 1 {
        return error("invalid expression received: only one operand found");
    } else {
        Operator firstOperator = operators[0];
        float firstOperand = operands[0];
        if operands.length() == 2 {
            return {
                firstOperand: firstOperand,
                secondOperand: operands[1],
                operator: firstOperator
            };
        } else {
            Expression generatedOperand = check generateExpression(operands.slice(1), operators.slice(1));
            return {
                firstOperand: firstOperand,
                secondOperand: generatedOperand,
                operator: firstOperator
            };
        }
    }
}
