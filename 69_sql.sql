USE mavenfuzzyfactory;

CREATE TEMPORARY TABLE IF NOT EXISTS temp AS
    WITH sessions_cte AS (
        SELECT
            DATE(created_at) AS the_date
            , HOUR(created_at) AS the_hour
            , CASE WHEN WEEKDAY(created_at) = 0 THEN 1 ELSE NULL END AS mon
            , CASE WHEN WEEKDAY(created_at) = 1 THEN 1 ELSE NULL END AS tue
            , CASE WHEN WEEKDAY(created_at) = 2 THEN 1 ELSE NULL END AS wed
            , CASE WHEN WEEKDAY(created_at) = 3 THEN 1 ELSE NULL END AS thu
            , CASE WHEN WEEKDAY(created_at) = 4 THEN 1 ELSE NULL END AS fri
            , CASE WHEN WEEKDAY(created_at) = 5 THEN 1 ELSE NULL END AS sat
            , CASE WHEN WEEKDAY(created_at) = 6 THEN 1 ELSE NULL END AS sun
            , website_session_id
        FROM website_sessions
        WHERE created_at BETWEEN '2012-09-15' AND '2012-11-16'
    )

    , final_cte AS(
        SELECT
            the_hour
            , ROUND(COALESCE(COUNT(DISTINCT CASE WHEN mon IS NOT NULL THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN mon IS NOT NULL THEN the_date ELSE NULL END), 0), 1) AS mon_avg
            , ROUND(COALESCE(COUNT(DISTINCT CASE WHEN tue IS NOT NULL THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN tue IS NOT NULL THEN the_date ELSE NULL END), 0), 1)AS tue_avg
            , ROUND(COALESCE(COUNT(DISTINCT CASE WHEN wed IS NOT NULL THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN wed IS NOT NULL THEN the_date ELSE NULL END), 0), 1) AS wed_avg
            , ROUND(COALESCE(COUNT(DISTINCT CASE WHEN thu IS NOT NULL THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN thu IS NOT NULL THEN the_date ELSE NULL END), 0), 1) AS thu_avg
            , ROUND(COALESCE(COUNT(DISTINCT CASE WHEN fri IS NOT NULL THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN fri IS NOT NULL THEN the_date ELSE NULL END), 0), 1) AS fri_avg
            , ROUND(COALESCE(COUNT(DISTINCT CASE WHEN sat IS NOT NULL THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN sat IS NOT NULL THEN the_date ELSE NULL END), 0), 1) AS sat_avg
            , ROUND(COALESCE(COUNT(DISTINCT CASE WHEN sun IS NOT NULL THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN sun IS NOT NULL THEN the_date ELSE NULL END), 0), 1) AS sun_avg
        FROM sessions_cte
        GROUP BY the_hour
    )

    SELECT * FROM final_cte;

SELECT * FROM temp;