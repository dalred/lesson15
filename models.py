from functions import connection_to_database


class Db_query:
    def __init__(self, db):
        self.db = db

    def get_item(self, item):
        query = f"""
                SELECT Animals_new.`index`, 
                Animals_new.animal_id, 
                Animals_new.name, 
                Animals_new.animal_type_id,
                Breeds.name as Breeds,
                date_of_birth, group_concat(distinct colors.name) as colors, 
                outcome_subtype, outcome_type, outcome_month, outcome_year, 
                age_upon_outcome from Animals_new
                left join Animal_colors on Animals_new.animal_id = Animal_colors.animal_id
                left join  Colors on colors.color_id = Animal_colors.color_id
                left join  outcomes on outcomes.animal_id = Animals_new.animal_id
                left join Breeds on Breeds.id=breeds_id
                where Animals_new.`index`={item}
                group by Animals_new.animal_id
                order by Animals_new.`index`"""
        result = connection_to_database(query, self.db)
        return result
