#include <string.h>
#include "crowbar.h"

MessageFormat crb_compile_error_message_format[] = {
    {"dummy"},
    {"A syntax error near ($(token))."},	//在($(token))附近发生语法错误.
    {"Incorrect character ($(bad_char))."},	//不正确的字符($(bad_char)).
    {"Duplication of function ($(name))."},	//函数名重复($(name)).
    {"dummy"},
};

MessageFormat crb_runtime_error_message_format[] = {
    {"dummy"},
    {"Cann't find variable ($(name))."},	//找不到变量($(name)).
    {"Cann't find function ($(name))."},	//找不到函数($(name)).
    {"The number of parameter list more than the definition."},		//传入的参数数量多于函数定义.
    {"The number of parameter list less than the definition."},		//传入的参数数量少于函数定义.
    {"The condition expression must be boolean type."},	//条件表达式的值必须是boolean型.
    {"The operand of minus must be number."},	//减法运算的操作数必须是数值类型.
    {"Incorrect operand type of $(operator)."},	//双目操作符$(operator)的操作数类型不正确.
    {"The $(operator) operator cann't be use as boolean."},	//$(operator)操作符不能用于boolean型.
    {"Please set path and open manner for fopen() (Both are string type)."},	//请为fopen()函数传入文件的路径和打开方式（两者都是字符串类型的.
    {"Please set File pointer for fclose()."},	//请为fclose()函数传入文件指针.
    {"Please set File pointer for fgets()."},	//请为fgets()函数传入文件指针.
    {"Please set File pointer and string for fputs()"},	//请为fputs()函数传入文件指针和字符串.
    {"Null can't be used in $(operator) operation, only in ==,!=."},	//null只能用于运算符 == 和 !=(不能进行$(operator)操作).
    {"Cann't be divided by 0."},		//不能被0除.
    {"The global variable $(name) doesn't exist."},		//全局变量$(name)不存在.
    {"Cann't use global keyword outside the function."},	//不能在函数外使用global语句.
    {"The operator $(operator) cann't be used as string type."},	//运算符$(operator)不能用于字符串类型.
    {"dummy"},
};
