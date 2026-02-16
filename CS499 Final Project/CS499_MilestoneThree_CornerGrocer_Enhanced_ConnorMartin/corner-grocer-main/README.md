# Corner Grocer Frequency Analysis System

## Overview

The Corner Grocer Frequency Analysis System is a C++ console application that analyzes grocery purchase data from a structured input file and generates frequency-based insights. The program reads item data, calculates purchase counts, and provides multiple reporting options through a user-friendly menu interface.

This project was enhanced as part of a Computer Science capstone portfolio to demonstrate growth in algorithm design, data structure selection, defensive programming, and secure coding practices.

---

## Key Features

- Case-insensitive item frequency search
- Alphabetical frequency listing (A–Z)
- Histogram visualization of item frequencies
- Sorting by frequency count (highest to lowest)
- Automatic generation of a backup frequency file (`frequency.dat`)
- Robust input validation for menu handling
- Safe file handling with fail-safe termination

---

## Technical Implementation

### Data Structures

- **`std::unordered_map`**
  - Used for efficient frequency counting
  - Provides average O(1) insertion and lookup
  - Demonstrates deliberate data structure selection for performance

- **`std::vector`**
  - Used for controlled sorting and presentation of results

### Algorithmic Complexity

- Frequency counting: **O(n)**
- Lookup operations: **O(1)** average
- Sorting operations: **O(n log n)**

Sorting by count uses `std::stable_sort` with deterministic tie-breaking to ensure predictable output.

---

## Defensive Programming & Security Considerations

The enhanced version incorporates multiple reliability and security-focused improvements:

- Input normalization to prevent case-based mismatches
- Validation of file access before processing
- Safe program termination if critical resources are unavailable
- Protection against operating on empty datasets
- Robust menu input handling to prevent infinite loops
- Deterministic sorting to ensure predictable execution behavior

These improvements demonstrate a security-aware development mindset focused on data integrity, safe failure handling, and predictable system behavior.

---

## File Structure

- `CornerGrocer.cpp` — Main application source code
- `CS210_Project_Three_Input_File.txt` — Input dataset
- `frequency.dat` — Generated backup file
- `README.md` — Project documentation

---

## How to Compile and Run

1. Ensure `CS210_Project_Three_Input_File.txt` is located in the same directory as the executable.
2. Compile using a C++17-compatible compiler.
3. Run the executable.
4. Follow the menu prompts to interact with the system.

---

## Professional Context

This artifact demonstrates:

- Algorithmic efficiency and complexity analysis
- Thoughtful data structure selection
- Code refactoring and modularization
- Defensive programming practices
- Secure and predictable system behavior
- Clear technical documentation

The enhancement reflects progression from functional implementation to production-quality, maintainable, and security-conscious software design.
