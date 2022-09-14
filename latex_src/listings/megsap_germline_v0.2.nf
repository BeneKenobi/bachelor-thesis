#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.sampledir = "${launchDir}/Sample_*"

process bam2FastQ {
    input:
    val sampleDirectory

    output:
    path "${sampleName}_R?_001.fastq.gz", emit: fastqs
    val "${sampleDirectory.toString()}", emit: sampledir

    publishDir "${sampleDirectory}", mode: 'move'

    script:
    sampleName=sampleDirectory.toString().tokenize('/').last().replaceFirst(/.*Sample_/, '')
    bamFile=files("${sampleDirectory.toString()}/*.bam")[0].toString()
    """
    /megSAP/data/tools/ngs-bits/bin/BamToFastq \
        -in $bamFile \
        -out1 \$PWD/${sampleName}_R1_001.fastq.gz \
        -out2 \$PWD/${sampleName}_R2_001.fastq.gz
    """
    }

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
    bam_channel = Channel.fromPath(params.sampledir, type: 'dir').map( { it -> 
        if (files("${it}/*.bam").size() >= 1 && files("${it}/*_R?_00?.fastq.gz").size() < 2) {
            it
        }
    })
    bam2FastQ(bam_channel)

    fastq_channel = Channel.fromPath(params.sampledir, type: 'dir').map( { it -> 
        if (files("${it}/*.bam").size() < 1 && files("${it}/*_R?_00?.fastq.gz").size() >= 2) {
            it
        }
    })
    
    fastq_channel.mix(bam2FastQ.out.sampledir) | megSAP
}