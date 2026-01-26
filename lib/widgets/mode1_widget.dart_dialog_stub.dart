  void _showMaterialSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final appState = Provider.of<AppState>(context, listen: false);
        final l10n = AppLocalizations.of(context)!;
        
        final materials = appState.studyMaterials;
        final isWordMode = appState.recordTypeFilter == 'word';
        
        // Filter materials based on current Toggle
        final filteredMaterials = materials.where((m) {
           if (m['id'] == 0) return true; // Always show Basic
           final count = m[isWordMode ? 'word_count' : 'sentence_count'] as int? ?? 0;
           return count > 0;
        }).toList();

        return AlertDialog(
          title: Text(isWordMode ? l10n.tabWord : l10n.tabSentence), // "Word" or "Sentence"
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.all_inclusive, color: Colors.indigo),
                  title: Text(l10n.reviewAll),
                  onTap: () {
                    // Filter is already set by toggle, so just select -1
                    appState.selectMaterial(-1);
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ...filteredMaterials.map((m) {
                      String subject = m['subject'] as String;
                      // Localize Basic
                      if (m['id'] == 0) {
                        subject = isWordMode ? l10n.basicWords : l10n.basicSentences;
                      }
                      return ListTile(
                        leading: Icon(
                          isWordMode ? Icons.book : Icons.article, 
                          color: isWordMode ? Colors.blueAccent : Colors.deepOrangeAccent
                        ),
                        title: Text(subject),
                        subtitle: Text(
                          // Show count for current mode only? Or both?
                          // Let's show count for current type.
                          '${isWordMode ? l10n.wordModeLabel : l10n.labelSentence}: ${m[isWordMode ? 'word_count' : 'sentence_count']}'
                        ),
                        onTap: () {
                           // Filter is already set, just select ID
                           appState.selectMaterial(m['id'] as int);
                           Navigator.pop(context);
                        },
                      );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }
}
