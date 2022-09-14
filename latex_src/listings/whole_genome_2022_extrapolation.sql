SELECT AN.datum AS 'Date'
FROM av_analytik AS AN
    INNER JOIN av_status_stamm AS ANS ON ANS.guid_status_stamm = AN.guid_status_stamm
    AND ANS.status_bezeichnung NOT LIKE 'ungültig'
WHERE AN.guid_analytik_stamm IN (
        -- HGE_Genom
        '0547c8a1-e48c-4050-9ee5-307ac032c666',
        -- HGE_rapidGenom
        '0ab57b84-4cf6-4383-927c-7143b81e37ba',
        -- FGEN_Genom
        'fff951e3-9f5a-40a8-bb6f-888cdc24de7a'
    )
    AND AN.datum BETWEEN '01.01.2022' AND '31.12.2022'
ORDER BY AN.datum ASC