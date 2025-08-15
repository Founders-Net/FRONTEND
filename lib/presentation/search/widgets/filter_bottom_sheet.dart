import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_founders/presentation/search/bloc/search_bloc.dart';
import 'package:flutter_founders/presentation/search/bloc/search_event.dart';
import 'tag_subtags.dart';

class FilterBottomSheet extends StatefulWidget {
  final SearchBloc searchBloc;
  const FilterBottomSheet({super.key, required this.searchBloc});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // ✅ API expects a single country string (or omit). Use String? instead of List<String>.
  String? selectedCountry;

  // Tags
  List<String> selectedMainTags = [];
  List<String> selectedSubTags = [];
  Set<String> expandedTags = {};

  // No backend filter for this yet; keep UI toggle but it won't affect the request.
  bool isFoundersOnly = false;

  void _resetFilters() {
    setState(() {
      selectedCountry = null;
      selectedMainTags = [];
      selectedSubTags = [];
      expandedTags.clear();
      isFoundersOnly = false;
    });
  }

  void _applyFilters() {
    // Flatten main+sub tags into a single Set<String>
    final selected = <String>{...selectedMainTags, ...selectedSubTags};

    // ✅ Dispatch new Bloc event that matches backend spec
    widget.searchBloc.add(
      ApplyFilters(
        country: (selectedCountry == null || selectedCountry!.trim().isEmpty)
            ? null
            : selectedCountry!.trim(),
        selectedTags: selected,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: const BoxDecoration(
            color: Color(0xFF191919),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _resetFilters,
                    child: const Text('Очистить', style: _smallTextStyle),
                  ),
                  const Text('Фильтры', style: _headerTextStyle),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Отменить', style: _smallTextStyle),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Country
              const Text('Страна', style: _sectionTextStyle),
              const SizedBox(height: 13),
              GestureDetector(
                onTap: _openCountryPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          (selectedCountry == null || selectedCountry!.isEmpty)
                              ? 'Выберите'
                              : selectedCountry!,
                          style: const TextStyle(
                            color: Color(0xFFDFDFDF),
                            fontSize: 14,
                            fontFamily: 'InriaSans',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Tags (main + sub)
              const Text('Сфера деятельности', style: _sectionTextStyle),
              const SizedBox(height: 10),
              ...tagSubTags.entries.map((entry) {
                final tag = entry.key;
                final subTags = entry.value;
                final expanded = expandedTags.contains(tag);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      onExpansionChanged: (isOpen) {
                        setState(() {
                          if (isOpen) {
                            expandedTags.add(tag);
                          } else {
                            expandedTags.remove(tag);
                          }
                        });
                      },
                      trailing: const SizedBox.shrink(),
                      backgroundColor: Colors.transparent,
                      collapsedBackgroundColor: Colors.transparent,
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10),
                          AnimatedRotation(
                            turns: expanded ? 0.75 : 0.5,
                            duration: const Duration(milliseconds: 200),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(tag, style: _tagTextStyle)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: _buildCheckbox(
                              isChecked: selectedMainTags.contains(tag),
                              onChanged: () => setState(() {
                                if (selectedMainTags.contains(tag)) {
                                  selectedMainTags.remove(tag);
                                } else {
                                  selectedMainTags.add(tag);
                                }
                              }),
                            ),
                          ),
                        ],
                      ),
                      children: [
                        for (final subTag in subTags)
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 15,
                              left: 40,
                              bottom: 15,
                              right: 32,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(child: Text(subTag, style: _tagTextStyle)),
                                _buildCheckbox(
                                  isChecked: selectedSubTags.contains(subTag),
                                  onChanged: () => setState(() {
                                    if (selectedSubTags.contains(subTag)) {
                                      selectedSubTags.remove(subTag);
                                    } else {
                                      selectedSubTags.add(subTag);
                                    }
                                  }),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),

              // Founders-only (no backend filter right now)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Партнёры фаундерс', style: _sectionTextStyle),
                  Switch(
                    value: isFoundersOnly,
                    onChanged: (val) => setState(() => isFoundersOnly = val),
                    activeColor: const Color(0xFFAF925D),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Apply button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAF925D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Применить',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'InriaSans',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCheckbox({required bool isChecked, required VoidCallback onChanged}) {
    return GestureDetector(
      onTap: onChanged,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isChecked ? const Color(0xFFD9D9D9) : Colors.transparent,
          border: Border.all(color: const Color(0xFFDFDFDF), width: 1.2),
        ),
        child: Icon(
          Icons.check,
          size: 16,
          color: isChecked ? Colors.black : Colors.transparent,
        ),
      ),
    );
  }

  void _openCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      countryListTheme: CountryListThemeData(
        backgroundColor: Colors.black,
        textStyle: const TextStyle(color: Colors.white, fontFamily: 'InriaSans'),
        inputDecoration: const InputDecoration(
          labelText: 'Поиск страны',
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          // ✅ Single select
          if (selectedCountry == country.name) {
            selectedCountry = null; // toggle off
          } else {
            selectedCountry = country.name;
          }
        });
      },
    );
  }
}

const _headerTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontFamily: 'InriaSans',
  fontWeight: FontWeight.w400,
  height: 1.0,
  letterSpacing: -0.03,
);

const _sectionTextStyle = _headerTextStyle;

const _smallTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 15,
  fontFamily: 'InriaSans',
  fontWeight: FontWeight.w400,
  height: 1.22,
  letterSpacing: -0.03,
);

const _tagTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 15,
  fontFamily: 'InriaSans',
  height: 1.22,
  letterSpacing: -0.03,
);
