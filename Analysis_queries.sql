-- Cleanup Metadata table and remove any duplicate movie entries
delete from movies_metadata
where movie_id in(
	(select m_id from 
		(select distinct movie_id as m_id from movies_metadata
			group by movie_id having count(*) > 1) AS m
		)
	);
    
-- from the finance table remove movies that have 0 budget or revenue
delete from movies_finance 
where movie_id in (
	(select m_id from 
		(select distinct movie_id as m_id from movies_finance
			where Budget = 0 or Revenue = 0) AS m
		)
	);
    

-- count movies by genres by year.. 
select description as Genres, release_year, count(*) as Movie_count from
(Select mm.movie_id, gm.description, year(mm.release_date) as release_year
	from movies_metadata mm,  movies_genres mg, genres_master gm
	where mm.movie_id = mg.movie_id
    and mg.genres_id = gm.genres_id) as temp
    group by 1,2;

