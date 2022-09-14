#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.sampledir = "${launchDir}/Sample_*"

process megSAP {
    input:
    val sampleDirectory

    script:
    containerDirectory=sampleDirectory.toString().replaceFirst(/\/mnt\/hgenet/, '')
    sampleName=sampleDirectory.toString().tokenize('/').last().replaceFirst(/.*Sample_/, '')
    """
    php /megSAP/src/Pipelines/analyze.php -folder $containerDirectory -name $sampleName -use_dragen -no_abra -system /NGS_Daten_Test/Manifest/NGSD/WGS_lotus_GRCh38.ini -threads 12
    """
}

workflow {
    Channel.fromPath(params.sampledir, type: 'dir') | megSAP
}