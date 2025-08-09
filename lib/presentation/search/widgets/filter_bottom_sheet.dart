import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/presentation/search/bloc/search_bloc.dart';
import 'package:flutter_founders/presentation/search/bloc/search_event.dart';
import 'package:flutter_founders/presentation/search/bloc/search_state.dart';

class FilterBottomSheet extends StatefulWidget {
  final SearchBloc searchBloc;
  const FilterBottomSheet({super.key, required this.searchBloc});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _country;                     // single country (API expects one)
  final Set<String> _selectedMain = {}; // UI selection
  final Set<String> _selectedSub  = {};
  final Set<String> _expanded     = {};

  void _reset() {
    setState(() {
      _country = null;
      _selectedMain.clear();
      _selectedSub.clear();
      _expanded.clear();
    });
    // Optional: also clear server filters for immediate effect
    widget.searchBloc.add(const ClearFilters());
    Navigator.pop(context);
  }

  void _apply() {
    final merged = {..._selectedMain, ..._selectedSub};
    widget.searchBloc.add(ApplyFilters(country: _country, selectedTags: merged));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: widget.searchBloc,
      builder: (context, state) {
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
                      GestureDetector(onTap: _reset, child: const Text('Очистить', style: _smallTextStyle)),
                      const Text('Фильтры', style: _headerTextStyle),
                      GestureDetector(onTap: () => Navigator.pop(context), child: const Text('Отменить', style: _smallTextStyle)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Country (single)
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
                              _country ?? 'Выберите',
                              style: const TextStyle(color: Color(0xFFDFDFDF), fontSize: 14, fontFamily: 'InriaSans'),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, color: Colors.white),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Tags (dynamic from /api/tags)
                  const Text('Сфера деятельности', style: _sectionTextStyle),
                  const SizedBox(height: 10),

                  if (state.availableTags.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(),
                    )
                  else
                    ...state.availableTags.map((tagItem) {
                      final tag = tagItem.name;
                      final subs = tagItem.subtags;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            onExpansionChanged: (expanded) => setState(() => expanded ? _expanded.add(tag) : _expanded.remove(tag)),
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
                                  turns: _expanded.contains(tag) ? 0.75 : 0.5,
                                  duration: const Duration(milliseconds: 200),
                                  child: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(tag, style: _tagTextStyle)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 1),
                                  child: _buildCheckbox(
                                    isChecked: _selectedMain.contains(tag),
                                    onChanged: () => setState(() {
                                      _selectedMain.contains(tag) ? _selectedMain.remove(tag) : _selectedMain.add(tag);
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            children: subs.map((sub) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 15, left: 40, bottom: 15, right: 32),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(child: Text(sub, style: _tagTextStyle)),
                                    _buildCheckbox(
                                      isChecked: _selectedSub.contains(sub),
                                      onChanged: () => setState(() {
                                        _selectedSub.contains(sub) ? _selectedSub.remove(sub) : _selectedSub.add(sub);
                                      }),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }).toList(),

                  const SizedBox(height: 24),

                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _apply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAF925D),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Применить', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'InriaSans')),
                    ),
                  ),
                ],
              ),
            );
          },
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
        child: Icon(Icons.check, size: 16, color: isChecked ? Colors.black : Colors.transparent),
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
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
      ),
      onSelect: (Country c) => setState(() => _country = c.name),
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
