-- Analytics SQL

-- Total Count
SELECT count(1)
FROM CACHE_LOG;

-- Analytics
select status, count(1)
from (SELECT case when TIMESTAMP < datetime('now', '-5 days') then 'old' else 'current' end as status
      from CACHE_LOG) statusview
group by status;
