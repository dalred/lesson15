# Прочитать

Хотелось бы чтобы было пояснение, как можно было написать данный запрос по другому в SQLite, 
кроме той версии, которая представлена в моем проекте.
`UPDATE Animals_new
set breeds_id=breeed.id
FROM (SELECT id, animals.animal_id from Breeds
join Animals on Breeds.name=animals.breed
) as breeed
where Animals_new.animal_id=breeed.animal_id`