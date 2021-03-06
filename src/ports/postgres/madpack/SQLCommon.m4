/**
 * PostgreSQL include file for sql_in files.
 *
 * We currently use m4, and m4 is a pain. Unfortunately, there seems no easy way
 * to escape the quote string, so we change it at the beginning and restore at
 * the end.
 * m4_changequote(<!,!>)
 */

/*
 * PythonFunction
 *
 * @param $1 directory
 * @param $2 python file (without suffix)
 * @param $3 function
 *
 * Example:
 * CREATE FUNCTION MADLIB_SCHEMA.logregr_coef(
 *     "source" VARCHAR,
 *     "depColumn" VARCHAR,
 *     "indepColumn" VARCHAR)
 * RETURNS DOUBLE PRECISION[]
 * AS $$PythonFunction(regress, logistic, compute_logregr_coef)$$
 * LANGUAGE plpythonu VOLATILE;
 */ 
m4_define(<!PythonFunction!>, <!
    import sys
    from inspect import getframeinfo, currentframe
    try:
        from $1 import $2
    except:
        sys.path.append("PLPYTHON_LIBDIR")
        from $1 import $2
    
    # Retrieve the schema name of the current function
    # Make it available as variable: MADlibSchema
    fname = getframeinfo(currentframe()).function
    foid  = fname.rsplit('_',1)[1]

    # plpython names its functions "__plpython_procedure_<function name>_<oid>",
    # of which we want the oid
    rv = plpy.execute('SELECT nspname, proname FROM pg_proc p ' \
         'JOIN pg_namespace n ON (p.pronamespace = n.oid) ' \
         'WHERE p.oid = %s' % foid, 1)

    global MADlibSchema
    MADlibSchema = rv[0]['nspname']
    
    return $2.$3(**globals())
!>)

/*
 * IterativeAlgorithm
 *
 * @param $1 compute function with argument list
 * @param $2 result function name
 *
 * Example:
 * CREATE FUNCTION MADLIB_SCHEMA.logregr(
 *     "source" VARCHAR,
 *     "depColumn" VARCHAR,
 *     "indepColumn" VARCHAR)
 * RETURNS INTEGER
 * AS $$IterativeAlgorithm(`compute_logregr($1, $2, $3, $4, $5, $6)',
 *   internal_logregr_irls_result)$$
 * LANGUAGE plpgsql VOLATILE;
 *
 
m4_define(<!IterativeAlgorithm!>, <!
DECLARE
    iteration INTEGER;
BEGIN
    SELECT MADLIB_SCHEMA.$1 INTO iteration;
    SELECT 
        
END;
!>)
    SELECT MADLIB_SCHEMA.compute_logregr($1, $2, $3, $4, $5, $6);
    SELECT MADLIB_SCHEMA.internal_logregr_irls_result(state)
    FROM _madlib_iterative_alg
    WHERE iteration = (SELECT max(iteration) FROM _madlib_iterative_alg);
*/

/*
 * PythonFunctionBodyOnly
 *
 * @param $1 directory
 * @param $2 python file (without suffix)
 *
 */ 
m4_define(<!PythonFunctionBodyOnly!>, <!
    import sys
    from inspect import getframeinfo, currentframe
    try:
        from $1 import $2
    except:
        sys.path.append("PLPYTHON_LIBDIR")
        from $1 import $2
    
    # Retrieve the schema name of the current function
    # Make it available as variable: MADlibSchema
    fname = getframeinfo(currentframe()).function
    foid  = fname.rsplit('_',1)[1]

    # plpython names its functions "__plpython_procedure_<function name>_<oid>",
    # of which we want the oid
    rv = plpy.execute('SELECT nspname, proname FROM pg_proc p ' \
         'JOIN pg_namespace n ON (p.pronamespace = n.oid) ' \
         'WHERE p.oid = %s' % foid, 1)

    global MADlibSchema
    MADlibSchema = rv[0]['nspname']    
!>)

/*
 * Repetition: m4 is a lousy preprocessor. We change the quote character back to
 * their defaults.
 * m4_changequote(<!`!>,<!'!>)
 */
