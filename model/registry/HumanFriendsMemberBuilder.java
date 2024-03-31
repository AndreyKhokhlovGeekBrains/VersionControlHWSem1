package model.registry;
// HumanFriendsMember(long id, long petID, String name, LocalDate birthdate, List<String> commands)

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import model.Animals;
import model.PackAnimals;
import model.Pets;
import model.member.HumanFriendsItem;
import model.member.HumanFriendsMember;

public class HumanFriendsMemberBuilder {
    private Integer id = 1;
    private Integer animalId;
    private String animalDescription;
    private Integer animalTypeId;
    private String animalTypeDescription;
    private String name;
    private LocalDate birthdate;
    private List<String> commands = new ArrayList<String>();

    public void assignID(List<? extends HumanFriendsItem> humanFriendsMembersList){
        int maxID = 0;
        for(HumanFriendsItem member: humanFriendsMembersList){
            if(maxID < member.getId()){
                maxID = member.getId();
            }
        }
        id = maxID + 1;
    }

    public HumanFriendsMember build (String animalTypeDescription, String name, LocalDate birthdate, List<String> commands) {
        String petType;
        Pets pets = new Pets();
        PackAnimals packAnimals = new PackAnimals();
        Animals animals = new Animals();

        if(checkAnimalTypeDescription(animalTypeDescription)) {

            if(pets.getPetsList().containsValue(animalTypeDescription)) {
                petType = pets.getPetType();
            } else {
                petType = packAnimals.getPetType();
            }

            animalTypeId = getAnimalTypeId(animalTypeDescription);
            animalId = animals.getIdByDescription(petType);
            animalDescription = animals.getDescriptionByID(animalId);
            this.commands = commands;
            
            return new HumanFriendsMember(id++, animalTypeId, animalTypeDescription, animalId, animalDescription, name, birthdate, commands);
        } else {
           throw new IllegalArgumentException("There is no specified animal type");
       }
    }

    public Integer getAnimalTypeId (String prompt) {
        Pets pets = new Pets();
        PackAnimals packAnimals = new PackAnimals();
        Integer idValue = pets.getID(prompt);

        if(!checkAnimalTypeDescription(prompt)) {
            throw new IllegalArgumentException("There is no specified animal type");
        }

        if(idValue == -1) {
            idValue = packAnimals.getID(prompt);
        }

        return idValue;
    }

    public boolean checkAnimalTypeDescription(String animalTypeDescription) {
        Pets pets = new Pets();
        PackAnimals packAnimals = new PackAnimals();
        
        if(pets.getPetsList().containsValue(animalTypeDescription) || packAnimals.getPackAnimalsList().containsValue(animalTypeDescription)) {
            return true;
        }
        return false;
    }

}
