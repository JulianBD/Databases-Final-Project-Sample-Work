USE cs315;

DELIMITER //

/* Most popular artist on Billboard for each year: 
e.g., the artist whose songs had the highest average ranking that year.
*/
DROP PROCEDURE IF EXISTS MostPopularBillboard //
CREATE PROCEDURE MostPopularBillboard(IN start_year INT, end_year INT)
BEGIN
    SELECT x.song,  x.year, average as avg_rank
	FROM (
		SELECT song_id, song, avg(rank) as average, year
		FROM song
        WHERE year between start_year and end_year
		GROUP BY song_id, song, year
	ORDER BY year desc
    ) x
    GROUP BY x.year
    HAVING min(x.average);
END
//

/* GRAPH Return the number of songs each year, from YEAR to YEAR, which contain WORD in the lyrics. */
DROP PROCEDURE IF EXISTS SongsBySubject //
CREATE PROCEDURE SongsBySubject(IN start_year INT, IN end_year INT, IN keyword varchar(96))
BEGIN
    SELECT year, count(x.year) as num_songs
    FROM (
            SELECT DISTINCT song, artist, year
            FROM song
            WHERE lyrics like concat('%', keyword, '%')
            AND year BETWEEN start_year and end_year
        ) x
    GROUP BY year;
END
//

/*Albums most featured on Billboard 100, complete with counts of how many songs from the album were featured. */
DROP PROCEDURE IF EXISTS MostFeaturedAlbums //
CREATE PROCEDURE MostFeaturedAlbums() 
BEGIN
    SELECT album_name, count(a.album_id) as num_times
    FROM song s, album a, song_album n
    WHERE s.song_id = n.song_id 
        AND n.album_id = a.album_id
        AND a.album_name <> "NO ALBUM"
        AND a.album_name NOT LIKE "%hits%"
        AND a.album_name NOT LIKE "%greatest%"
        AND a.album_name NOT LIKE "%songs%"
        AND a.album_name NOT LIKE "%collection%"
        AND a.album_name NOT LIKE "%best of%"
        AND a.album_name NOT LIKE "%gold%"
        AND a.album_name NOT LIKE "%anthology%"
    GROUP BY a.album_id
    ORDER BY num_times desc;
END
//




