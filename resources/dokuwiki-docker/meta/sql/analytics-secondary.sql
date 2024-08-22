-- Analytics SQL

-- Total Count
SELECT count(1)
FROM CACHE_LOG;

-- Cache Log Old vs New
select status, count(1)
from (SELECT case when TIMESTAMP < datetime('now', '-5 days') then 'old' else 'current' end as status
      from CACHE_LOG) statusview
group by status;

-- Base
select * FROM REDIRECTIONS_LOG limit 10;

-- Hourly Distribution of redirection yesterday
SELECT strftime('%H', TIMESTAMP) AS hour,
       COUNT(*) AS count
FROM REDIRECTIONS_LOG
where DATE(TIMESTAMP) = DATE('now', '-1 day')
GROUP BY hour
ORDER BY hour;

-- Daily
SELECT strftime('%Y-%m-%d', TIMESTAMP) AS day,
       COUNT(*) AS count
FROM REDIRECTIONS_LOG
GROUP BY day
ORDER BY day;


-- Redirection by Type
SELECT type,
       COUNT(*) AS count
FROM REDIRECTIONS_LOG
GROUP BY type
ORDER BY count desc;

-- OS Size
-- du -sh  ./meta/combo-secondary.sqlite3
-- Need compilations
-- https://www.sqlite.org/dbstat.html
-- https://www.sqlite.org/sqlanalyze.html - sqlite3_analyzer use dbstat to
SELECT
    name AS table_name,
    SUM(pgsize) / (1024 * 1024) AS size_mb
FROM
    sqlite_schema
        JOIN
    dbstat ON name = dbstat.name
WHERE
    type = 'table'
GROUP BY
    name
ORDER BY
    size_mb DESC;