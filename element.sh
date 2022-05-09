#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# if no arugument
if [[ -z $1 ]]
then
    echo "Please provide an element as an argument."
# if argument available
else

    ## try fetching result
    # if argument is number
    if [[ $1 =~ ^[0-9]+$ ]]
    then
        RES=$($PSQL "SELECT
                        atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius
                    FROM
                        properties
                    INNER JOIN elements using (atomic_number)
                    INNER JOIN types using (type_id)
                    WHERE
                        atomic_number = $1")
    else
        RES=$($PSQL "SELECT
                        atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius
                    FROM
                        properties
                    INNER JOIN elements using (atomic_number)
                    INNER JOIN types using (type_id)
                    WHERE
                        symbol = '$1' 
                        or
                        name = '$1'
                        ")
    fi

    # if res is empty
    if [[ -z $RES ]]
    then
        echo "I could not find that element in the database."
    # if res available
    else
        read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS <<< $RES
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    fi
fi
