#include <iostream>
#include <fstream>
#include <string>
#include <unordered_map>
#include <vector>
#include <algorithm>
#include <iomanip>
#include <cctype>
#include <limits>

class GroceryTracker {
private:
    std::unordered_map<std::string, int> itemFrequency;

    // Normalize input to lowercase for consistent storage and lookup
    static std::string normalize(const std::string& input) {
        std::string output;
        output.reserve(input.size());
        for (unsigned char ch : input) {
            output.push_back(static_cast<char>(std::tolower(ch)));
        }
        return output;
    }

    // Utility: return sorted vector copy (avoids repeated sorting logic)
    std::vector<std::pair<std::string, int>> getSortedItemsByName() const {
        std::vector<std::pair<std::string, int>> items(itemFrequency.begin(), itemFrequency.end());
        std::sort(items.begin(), items.end(),
            [](const auto& a, const auto& b) {
                return a.first < b.first;
            });
        return items;
    }

public:
    bool loadItemsFromFile(const std::string& filename) {
        std::ifstream inputFile(filename);

        if (!inputFile.is_open()) {
            std::cerr << "Error: Could not open input file: " << filename << "\n";
            return false;
        }

        std::string item;
        while (inputFile >> item) {
            ++itemFrequency[normalize(item)];
        }

        if (itemFrequency.empty()) {
            std::cerr << "Warning: Input file was empty or improperly formatted.\n";
        }

        return true;
    }

    bool writeBackupToFile(const std::string& filename) const {
        std::ofstream outFile(filename);

        if (!outFile.is_open()) {
            std::cerr << "Error: Could not write to backup file: " << filename << "\n";
            return false;
        }

        const auto items = getSortedItemsByName();

        for (const auto& pair : items) {
            outFile << pair.first << " " << pair.second << "\n";
        }

        return true;
    }

    void printItemFrequency(const std::string& itemName) const {
        const std::string key = normalize(itemName);
        auto it = itemFrequency.find(key);

        if (it != itemFrequency.end()) {
            std::cout << itemName << " was purchased "
                      << it->second << " times.\n";
        } else {
            std::cout << itemName << " was not found in the records.\n";
        }
    }

    void printAllFrequencies() const {
        if (itemFrequency.empty()) {
            std::cout << "No purchase data available.\n";
            return;
        }

        std::cout << "\nItem Purchase Frequencies (A-Z):\n";
        const auto items = getSortedItemsByName();

        for (const auto& pair : items) {
            std::cout << std::setw(15) << std::left
                      << pair.first << " "
                      << pair.second << "\n";
        }
    }

    void printFrequenciesByCount(bool descending = true) const {
        if (itemFrequency.empty()) {
            std::cout << "No purchase data available.\n";
            return;
        }

        std::cout << "\nItem Purchase Frequencies (by count):\n";

        std::vector<std::pair<std::string, int>> items(
            itemFrequency.begin(),
            itemFrequency.end()
        );

        std::stable_sort(items.begin(), items.end(),
            [descending](const auto& a, const auto& b) {
                if (a.second == b.second)
                    return a.first < b.first; // tie-breaker
                return descending ? (a.second > b.second)
                                  : (a.second < b.second);
            });

        for (const auto& pair : items) {
            std::cout << std::setw(15) << std::left
                      << pair.first << " "
                      << pair.second << "\n";
        }
    }

    void printHistogram() const {
        if (itemFrequency.empty()) {
            std::cout << "No purchase data available.\n";
            return;
        }

        std::cout << "\nPurchase Frequency Histogram:\n";

        const auto items = getSortedItemsByName();

        for (const auto& pair : items) {
            std::cout << std::setw(15) << std::left
                      << pair.first << " ";
            std::cout << std::string(pair.second, '*') << "\n";
        }
    }
};

void displayMenu() {
    std::cout << "\n--- Corner Grocer Menu ---\n"
              << "1. Search for item frequency\n"
              << "2. Display all item frequencies (A-Z)\n"
              << "3. Display histogram of item frequencies\n"
              << "4. Display item frequencies sorted by count\n"
              << "5. Exit\n"
              << "Enter your choice: ";
}

int readMenuChoice() {
    int choice;

    while (true) {
        if (std::cin >> choice) {
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
            return choice;
        }

        std::cout << "Invalid input. Please enter a number.\n";
        std::cin.clear();
        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
        displayMenu();
    }
}

int main() {
    GroceryTracker tracker;

    if (!tracker.loadItemsFromFile("CS210_Project_Three_Input_File.txt")) {
        return 1; // Fail safely if file fails
    }

    tracker.writeBackupToFile("frequency.dat");

    int choice;
    std::string itemName;

    do {
        displayMenu();
        choice = readMenuChoice();

        switch (choice) {
        case 1:
            std::cout << "Enter item name: ";
            std::getline(std::cin, itemName);
            tracker.printItemFrequency(itemName);
            break;

        case 2:
            tracker.printAllFrequencies();
            break;

        case 3:
            tracker.printHistogram();
            break;

        case 4:
            tracker.printFrequenciesByCount(true);
            break;

        case 5:
            std::cout << "Exiting program. Goodbye!\n";
            break;

        default:
            std::cout << "Invalid input. Please choose 1–5.\n";
        }

    } while (choice != 5);

    return 0;
}