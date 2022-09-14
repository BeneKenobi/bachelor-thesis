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

process megSAPma {
    input:
    val sampleDirectory

    output:
    val "$sampleDirectory"

    script:
    containerDirectory=sampleDirectory.toString().replaceFirst(/\/mnt\/hgenet/, '')
    sampleName=sampleDirectory.toString().tokenize('/').last().replaceFirst(/.*Sample_/, '')
    threads=task.cpus
    steps='ma'
    template 'megsap_germline.sh'
}

process megSAPvc {                
    input:
    val sampleDirectory

    output:
    val "$sampleDirectory"

    script:
    containerDirectory=sampleDirectory.toString().replaceFirst(/\/mnt\/hgenet/, '')
    sampleName=sampleDirectory.toString().tokenize('/').last().replaceFirst(/.*Sample_/, '')
    threads=task.cpus
    steps='vc'
    template 'megsap_germline.sh'
}

process megSAPcn {                
    input:
    val sampleDirectory

    output:
    val "$sampleDirectory"

    script:
    containerDirectory=sampleDirectory.toString().replaceFirst(/\/mnt\/hgenet/, '')
    sampleName=sampleDirectory.toString().tokenize('/').last().replaceFirst(/.*Sample_/, '')
    threads=task.cpus
    steps='cn'
    template 'megsap_germline.sh'
}

process megSAPsv {                
    input:
    val sampleDirectory

    output:
    val "$sampleDirectory"

    script:
    containerDirectory=sampleDirectory.toString().replaceFirst(/\/mnt\/hgenet/, '')
    sampleName=sampleDirectory.toString().tokenize('/').last().replaceFirst(/.*Sample_/, '')
    threads=task.cpus
    steps='sv'
    template 'megsap_germline.sh'
}

process megSAPdb {                
    input:
    val sampleDirectory

    output:
    val "$sampleDirectory"

    script:
    containerDirectory=sampleDirectory.toString().replaceFirst(/\/mnt\/hgenet/, '')
    sampleName=sampleDirectory.toString().tokenize('/').last().replaceFirst(/.*Sample_/, '')
    threads=task.cpus
    steps='db'
    template 'megsap_germline.sh'
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
    
    fastq_channel.mix(bam2FastQ.out.sampledir) | megSAPma | megSAPvc | megSAPcn | megSAPsv | megSAPdb
}