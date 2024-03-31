package presenter;
import java.time.LocalDate;
import java.util.List;
import java.util.Scanner;

import model.Service;
import model.member.HumanFriendsMember;
import model.registry.HumanFriends;
import view.View;

public class Presenter {
    private View view;
    private Service service;
    private Scanner scanner = new Scanner(System.in);

    public Presenter(View view) {
        this.view = view;
        service = new Service();
    }

    public void addHumanFriendsMember(String animalTypeDescription, String name, LocalDate birthdate, List<String> commands) {
        service.createHumanFriendsMember(animalTypeDescription, name, birthdate, commands);
    }

    public void getHumanFriendsRegistryInfo() {
        String answer = service.getHumanFriendsRegistryInfo();
        view.answer(answer);
    }

    public void save() {
        service.save();
    }

    public boolean checkAnimalTypeDescription(String description) {
        return service.checkAnimalTypeDescription(description);
    }

    public void deleteMember(int animalId) {
        service.deleteMember(animalId);
        String answer = service.getHumanFriendsRegistryInfo();
        view.answer(answer);
    }

    public void printCommands(int animalId) {
        String answer = service.printCommands(animalId);
        view.answer(answer);
    }

    public void addCommand(int animalId, String command) {
        String answer = service.addCommand(animalId, command);
        view.answer(answer);
    }

    public void delecteCommand(HumanFriendsMember member, int selectedCommandId) {
        String answer = service.deleteCommand(member, selectedCommandId);
        view.answer(answer);
    }

    public HumanFriends<HumanFriendsMember> getHumanFriendsRegistry() {
        return service.getHumanFriendsregistry();
    }

    public void sortByBirthdate() {
        service.sortByBirthdate();
        String answer = service.getHumanFriendsRegistryInfo();
        view.answer(answer);
    }

    public void countByAnimalType(String animalType) {
        String answer = service.countByAnimalType(animalType);
        view.answer(answer);
    }

}