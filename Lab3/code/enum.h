#ifndef ENUM_H
#define ENUM_H

// define node type
typedef enum _nodeType {
    TOKEN_INT,
    TOKEN_HEX,
    TOKEN_OCT,
    TOKEN_FLOAT,
    TOKEN_ID,
    TOKEN_TYPE,
    TOKEN_OTHER,
    NOT_A_TOKEN

}NodeType;

typedef enum _kind { BASIC, ARRAY, STRUCTURE, FUNCTION } Kind;
typedef enum _basicType { INT_TYPE, FLOAT_TYPE } BasicType;
typedef enum _errorType {
    UNDEF_VAR = 1,         // Undefined Variable
    UNDEF_FUNC,            // Undefined Function
    REDEF_VAR,             // Redefined Variable
    REDEF_FUNC,            // Redefined Function
    TYPE_MISMATCH_ASSIGN,  // Type mismatchedfor assignment.
    LEFT_VAR_ASSIGN,  // The left-hand side of an assignment must be a variable.
    TYPE_MISMATCH_OP,      // Type mismatched for operands.
    TYPE_MISMATCH_RETURN,  // Type mismatched for return.
    FUNC_AGRC_MISMATCH,    // Function is not applicable for arguments
    NOT_A_ARRAY,           // Variable is not a Array
    NOT_A_FUNC,            // Variable is not a Function
    NOT_A_INT,             // Variable is not a Integer
    ILLEGAL_USE_DOT,       // Illegal use of "."
    NONEXISTFIELD,         // Non-existentfield
    REDEF_FEILD,           // Redefined field
    DUPLICATED_NAME,       // Duplicated name
    UNDEF_STRUCT           // Undefined structure
} ErrorType;

#endif
