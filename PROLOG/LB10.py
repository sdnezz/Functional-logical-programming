import itertools
from itertools import combinations, permutations


def write_to_file(filename, results, method_name):
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(f"{method_name}\n")
        for result in results:
            f.write(str(result) + '\n')


# 1. Размещения без повторений (A(7,3))
def arrangements_non_recursive(n=7, k=3):
    alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g'][:n]
    results = list(permutations(alphabet, k))
    write_to_file('arrangements_non_recursive.txt', results, "Arrangements Non-Recursive")
    return results


def arrangements_recursive(n=7, k=3):
    def generate_arr(current, alphabet, k, results):
        if len(current) == k:
            results.append(tuple(current))
            return
        for char in alphabet:
            if char not in current:
                generate_arr(current + [char], alphabet, k, results)

    alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g'][:n]
    results = []
    generate_arr([], alphabet, k, results)
    write_to_file('arrangements_recursive.txt', results, "Arrangements Recursive")
    return results


# 2. Подмножества (все подмножества множества из 7 элементов)
def subsets_non_recursive(n=7):
    alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g'][:n]
    results = []
    for r in range(n + 1):
        results.extend(combinations(alphabet, r))
    write_to_file('subsets_non_recursive.txt', results, "Subsets Non-Recursive")
    return results


def subsets_recursive(n=7):
    def generate_subsets(index, current, alphabet, results):
        if index == len(alphabet):
            results.append(tuple(current))
            return
        generate_subsets(index + 1, current, alphabet, results)
        generate_subsets(index + 1, current + [alphabet[index]], alphabet, results)

    alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g'][:n]
    results = []
    generate_subsets(0, [], alphabet, results)
    write_to_file('subsets_recursive.txt', results, "Subsets Recursive")
    return results


# 3. Слова длины 5, одна буква повторяется 2 раза, остальные не повторяются
def words5_non_recursive():
    alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g']
    results = []
    for repeat_char in alphabet:  # Выбираем букву, которая повторяется
        for other_chars in combinations([c for c in alphabet if c != repeat_char], 3):  # Выбираем 3 разные буквы
            for positions in combinations(range(5), 2):  # Выбираем 2 позиции для повторяющейся буквы
                word = [''] * 5
                for pos in positions:
                    word[pos] = repeat_char
                remaining_positions = [i for i in range(5) if i not in positions]
                for perm in permutations(other_chars, 3):  # Перестановки остальных букв
                    for i, char in enumerate(perm):
                        word[remaining_positions[i]] = char
                    results.append(''.join(word))
    write_to_file('words5_non_recursive.txt', results, "Words5 Non-Recursive")
    return results


def words5_recursive():
    def generate_words(pos, word, repeat_char, other_chars, used_positions, results):
        if pos == 5:
            results.append(''.join(word))
            return
        if len(used_positions) < 2:  # Можем поставить повторяющуюся букву
            word[pos] = repeat_char
            generate_words(pos + 1, word[:], repeat_char, other_chars, used_positions + [pos], results)
        if len(other_chars) > 0:  # Можем поставить одну из остальных букв
            for i, char in enumerate(other_chars):
                word[pos] = char
                new_chars = other_chars[:i] + other_chars[i + 1:]
                generate_words(pos + 1, word[:], repeat_char, new_chars, used_positions, results)

    alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g']
    results = []
    for repeat_char in alphabet:
        other_chars = [c for c in alphabet if c != repeat_char][:3]  # Берем 3 разные буквы
        generate_words(0, [''] * 5, repeat_char, other_chars, [], results)
    write_to_file('words5_recursive.txt', results, "Words5 Recursive")
    return results


# 4. Слова длины 7, одна буква повторяется 2 раза, одна 3 раза, остальные не повторяются
def words7_non_recursive():
    alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g']
    results = []
    for repeat2_char in alphabet:  # Буква, которая повторяется 2 раза
        for repeat3_char in [c for c in alphabet if c != repeat2_char]:  # Буква, которая повторяется 3 раза
            for other_chars in combinations([c for c in alphabet if c not in [repeat2_char, repeat3_char]],
                                            2):  # 2 разные буквы
                for pos2 in combinations(range(7), 2):  # Позиции для буквы с 2 повторами
                    for pos3 in combinations([i for i in range(7) if i not in pos2],
                                             3):  # Позиции для буквы с 3 повторами
                        word = [''] * 7
                        for p in pos2:
                            word[p] = repeat2_char
                        for p in pos3:
                            word[p] = repeat3_char
                        remaining_positions = [i for i in range(7) if i not in pos2 and i not in pos3]
                        for perm in permutations(other_chars, 2):  # Перестановки остальных букв
                            for i, char in enumerate(perm):
                                word[remaining_positions[i]] = char
                            results.append(''.join(word))
    write_to_file('words7_non_recursive.txt', results, "Words7 Non-Recursive")
    return results


def words7_recursive():
    def generate_words(pos, word, repeat2_char, repeat3_char, other_chars, count2, count3, results):
        if pos == 7:
            results.append(''.join(word))
            return
        if count2 < 2:  # Можем поставить букву с 2 повторами
            word[pos] = repeat2_char
            generate_words(pos + 1, word[:], repeat2_char, repeat3_char, other_chars, count2 + 1, count3, results)
        if count3 < 3:  # Можем поставить букву с 3 повторами
            word[pos] = repeat3_char
            generate_words(pos + 1, word[:], repeat2_char, repeat3_char, other_chars, count2, count3 + 1, results)
        if len(other_chars) > 0:  # Можем поставить одну из остальных букв
            for i, char in enumerate(other_chars):
                word[pos] = char
                new_chars = other_chars[:i] + other_chars[i + 1:]
                generate_words(pos + 1, word[:], repeat2_char, repeat3_char, new_chars, count2, count3, results)

    alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g']
    results = []
    for repeat2_char in alphabet:
        for repeat3_char in [c for c in alphabet if c != repeat2_char]:
            other_chars = [c for c in alphabet if c not in [repeat2_char, repeat3_char]][:2]  # Берем 2 разные буквы
            generate_words(0, [''] * 7, repeat2_char, repeat3_char, other_chars, 0, 0, results)
    write_to_file('words7_recursive.txt', results, "Words7 Recursive")
    return results


if __name__ == "__main__":
    arrangements_non_recursive()
    arrangements_recursive()
    subsets_non_recursive()
    subsets_recursive()
    words5_non_recursive()
    words5_recursive()
    words7_non_recursive()
    words7_recursive()