package model;
import java.time.LocalDate;
import java.util.Iterator;
import java.util.List;

import model.member.HumanFriendsMember;
import model.registry.HumanFriends;
import model.registry.HumanFriendsMemberBuilder;
import model.writer.FileHandler;
import model.writer.Writable;

public class Service {

    private HumanFriends<HumanFriendsMember> humanFriendsRegistry;
    private HumanFriendsMemberBuilder builder;
    private Writable writer;

    public Service(){
        builder = new HumanFriendsMemberBuilder();
        humanFriendsRegistry = new HumanFriends<>();
        writer = new FileHandler();
        loadHumanFriendsRegistry();
    }

    private void loadHumanFriendsRegistry() {
        try {
            HumanFriends<HumanFriendsMember> registry = (HumanFriends<HumanFriendsMember>) writer.read();
            if(registry != null && !registry.getHumanFriends().isEmpty()) {
                humanFriendsRegistry = registry;
                builder.assignID(humanFriendsRegistry.getHumanFriends());
            }   
        } catch (Exception e) {
            System.err.println("Error loading humanFriendsRegistry: " + e.getMessage());
        }
    }

    public void createHumanFriendsMember(String animalTypeDescription, String name, LocalDate birthdate, List<String> commands) {
        HumanFriendsMember member = builder.build(animalTypeDescription, name, birthdate, commands);
        humanFriendsRegistry.addHumanFriendsMember(member);
    }

    public String getHumanFriendsRegistryInfo() {
        return humanFriendsRegistry.getInfo();
    }

    public void save() {
        try {
            writer.save(humanFriendsRegistry);
        } catch (Exception e) {
            System.err.println("Error saving humanFriendsRegistry: " + e.getMessage());
        }
        
    }

    public boolean checkAnimalTypeDescription(String description) {
        return builder.checkAnimalTypeDescription(description);
    }

    public String deleteMember(int animalId) {
        Iterator<HumanFriendsMember> iterator = humanFriendsRegistry.iterator();

        while (iterator.hasNext()) {
            HumanFriendsMember member = iterator.next();
            if(member.getId() == animalId) {
                humanFriendsRegistry.remove(member);
                System.out.println("Ok");
                break;
            } else {
                System.out.println("No member found with id: " + animalId);
            }
        }
        return getHumanFriendsRegistryInfo();
    }

    public String printCommands(int id) {
    HumanFriendsMember selectedMember = null;
    Iterator<HumanFriendsMember> iterator = humanFriendsRegistry.iterator();
        while (iterator.hasNext()) {
            HumanFriendsMember member = iterator.next();
            if(member.getId() == id) {
                selectedMember = member;
                break;
            }
        }

        if (selectedMember != null) {
            return selectedMember.getCommands();
        } else {
            return "No member found with id: " + id;
        }
    }

     public String addCommand(int animalId, String command) {
        HumanFriendsMember selectedMember = null;
        Iterator<HumanFriendsMember> iterator = humanFriendsRegistry.iterator();
            while (iterator.hasNext()) {
                HumanFriendsMember member = iterator.next();
                if(member.getId() == animalId) {
                    selectedMember = member;
                    break;
                }
            }
        selectedMember.addNewCommand(command);
        return selectedMember.getInfo();
     }

     public String deleteCommand(HumanFriendsMember member, int selectedCommandId) {
        member.getCommands();
        member.deleteCommand(selectedCommandId);
        return member.getInfo();
     }

     public HumanFriends<HumanFriendsMember> getHumanFriendsregistry() {
        return humanFriendsRegistry;
     }

     public void sortByBirthdate() {
        humanFriendsRegistry.sortByBirthdate();
     }

     public String countByAnimalType(String animalDescription) {
        StringBuilder sb = new StringBuilder();
        HumanFriends<HumanFriendsMember> selectedAnimals = new HumanFriends<>();
        Iterator<HumanFriendsMember> iterator = humanFriendsRegistry.iterator();
            while (iterator.hasNext()) {
                HumanFriendsMember member = iterator.next();
                if(member.getAmimalDescription().equals(animalDescription)) {
                    selectedAnimals.getHumanFriends().add(member);
                }
            }

        sb.append(selectedAnimals.getInfo());
        sb.append("of the type " + animalDescription + ".");
        return sb.toString();
     }

}