process SAY_HELLO {

    output:
    path 'hello.txt'

    script:
    """
    echo "Hello Nextflow" > hello.txt
    """
}

workflow {
    SAY_HELLO()
}
