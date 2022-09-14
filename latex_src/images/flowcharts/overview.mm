flowchart TB
    start((" ")) --> sequencing[["sequencing"]]
    sequencing --> ma[["mapping"]]
    ma --> vc[["variant calling"]]
    vc --> cn[["copy number variant calling"]]
    cn --> sv[["structural variant calling"]]
    sv --> db[["database import"]]
    db --> done((" "))