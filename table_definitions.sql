SELECT * from billboard_data;

CREATE TABLE song AS (
SELECT DISTINCT song, artist 
FROM billboard_data);

ALTER TABLE song ADD song_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT;

CREATE TABLE album AS (
SELECT Album_1 AS album_name, album_id
FROM billboard_data
WHERE album_id IS NOT NULL) ;

ALTER TABLE album ADD PRIMARY KEY (album_id);

ALTER TABLE billboard_data DROP COLUMN album_id;
ALTER TABLE billboard_data DROP COLUMN Album_1;
    
CREATE TABLE song_album AS (
SELECT x.song_id, a.album_id 
FROM (
SELECT b.*, s.song_id
FROM billboard_data AS b join song AS s
ON b.song=s.song AND b.artist=s.artist) x 
JOIN album AS a
ON x.Album = a.album_name);

drop table new_song;

CREATE TABLE new_song AS (
SELECT s.song_id, b.rank, b.song, b.artist, b.`year`, b.lyrics
FROM billboard_data AS b INNER JOIN song AS s
ON b.song=s.song AND b.artist=s.artist);

SELECT *
FROM song AS s INNER JOIN new_song as n
ON s.song_id = n.song_id;

ALTER TABLE song RENAME old_song;
ALTER TABLE new_song RENAME song;


SELECT * FROM 
album AS a INNER JOIN reviews AS r
ON a.album_name = r.titlebillboard_data;

# Make new SQL statements to fix old table. 

CREATE TABLE test_new_album
AS (SELECT DISTINCT album, artist FROM billboard_data);

ALTER TABLE test_new_album add column album_id INT PRIMARY KEY AUTO_INCREMENT;

CREATE TABLE test_album_review AS 
	(SELECT t.album_id, r.reviewid
	FROM test_new_album AS t INNER JOIN reviews AS r ON t.album = r.title AND t.artist = r.artist);
    
SELECT DISTINCT a.reviewid, a.album_id
			FROM test_album_review AS a INNER JOIN test_album_review AS b on a.album_id = b.album_id
			WHERE a.reviewid <> b.reviewid;

CREATE TABLE test_song_album AS (
	SELECT DISTINCT x.song_id, a.album_id 
	FROM (
		SELECT b.*, s.song_id
			FROM billboard_data AS b INNER JOIN song AS s
				ON b.song=s.song AND b.artist=s.artist) x 
			INNER JOIN test_new_album AS a
				ON x.Album = a.album AND x.artist = a.artist;
	);

    SELECT x. genre, avg(x.rank) as average
    FROM (
		SELECT DISTINCT r.reviewid, g.genre, s.rank
		FROM (album_review AS a
			INNER JOIN reviews AS R 
				ON a.reviewid = r.reviewid
			INNER JOIN song_album AS y
				ON a.album_id = y.album_id
			INNER JOIN song AS s 
				ON y.song_id = s.song_id
			INNER JOIN genres AS g
				ON g.reviewid = r.reviewid)
    ) as x
    GROUP BY x.genre
    ORDER BY average asc;

SELECT (n.num1 / z.num2)
FROM (
		(SELECT x.label, x.genre, count(*) as num1
			FROM (
			SELECT DISTINCT r.reviewid, l.label, s.rank, g.genre
					FROM (album_review AS a
						INNER JOIN reviews AS R 
							ON a.reviewid = r.reviewid
						INNER JOIN song_album AS y
							ON a.album_id = y.album_id
						INNER JOIN song AS s 
							ON y.song_id = s.song_id
						INNER JOIN labels as l 
							ON l.reviewid = a.reviewid
						INNER JOIN genres as g
							ON g.reviewid = r.reviewid
					) AS x
		GROUP BY x.label, x.genre) AS n,
		(SELECT DISTINCT l.label, count(*) as num2
			FROM (album_review AS a
				INNER JOIN reviews AS R 
					ON a.reviewid = r.reviewid
				INNER JOIN song_album AS y
					ON a.album_id = y.album_id
				INNER JOIN song AS s 
					ON y.song_id = s.song_id
				INNER JOIN labels as l 
					ON l.reviewid = a.reviewid
				INNER JOIN genres as g
					ON g.reviewid = r.reviewid)
		) AS z
        GROUP BY label
		WHERE n.label = z.label
        
        
        SELECT x.label, x.genre, (x.num1/y.num2) as percent
        FROM (
			SELECT l.label, g.genre, count(*) as num1
			FROM (album_review AS a
				INNER JOIN reviews AS R 
					ON a.reviewid = r.reviewid
				INNER JOIN song_album AS y
					ON a.album_id = y.album_id
				INNER JOIN song AS s 
					ON y.song_id = s.song_id
				INNER JOIN labels as l 
					ON l.reviewid = a.reviewid
				INNER JOIN genres as g
					ON g.reviewid = r.reviewid)
			GROUP BY l.label, g.genre) AS x,
            (SELECT l.label, count(*) as num2
			FROM (album_review AS a
				INNER JOIN reviews AS R 
					ON a.reviewid = r.reviewid
				INNER JOIN song_album AS y
					ON a.album_id = y.album_id
				INNER JOIN song AS s 
					ON y.song_id = s.song_id
				INNER JOIN labels as l 
					ON l.reviewid = a.reviewid
				INNER JOIN genres as g
					ON g.reviewid = r.reviewid)
			GROUP BY l.label) AS y
            WHERE x.label = y.label;
        
        
SELECT s.song_id, s.song, avg(rank) as average 
FROM (album_review AS a
        INNER JOIN reviews AS R 
            ON a.reviewid = r.reviewid
        INNER JOIN song_album AS y
            ON a.album_id = y.album_id
        INNER JOIN song AS s 
            ON y.song_id = s.song_id) 
WHERE r.best_new_music = 1
GROUP BY song_id, song

            