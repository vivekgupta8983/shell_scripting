#!/bin/bash
## this is the example for artimetic operation 
##In this example we have used select loop

select opt in Addition Subtraction Multiplicatin Division exit
do 
    case $opt in 

    Addition)
            read -p "Enter num1: " num1
            read -p "Enter num2: " num2
            echo "The Addition of $num1 and $num2 is: $((num1+num2))"
            ;;
    Subtraction)
            read -p "Enter num1: " num1
            read -p "Enter num2: " num2
            echo "The Substraction of $num1 and $num2 is: $((num1-num2))"
            ;;
    Multiplicatin)
            read -p "Enter num1: " num1
            read -p "Enter num2: " num2
            echo "The Multiplication of $num1 and $num2 is: $((num1*num2))"
            ;;
    Division)
            read -p "Enter num1: " num1
            read -p "Enter num2: " num2
            echo "The Division of $num1 and $num2 is: $((num1/num2))"
            ;;
    exit)
            break 
            ;;

    *)
            echo " Invalid Options"
            ;;
    esac
done