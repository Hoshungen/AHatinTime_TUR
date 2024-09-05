class TurkceCeviri_HUD_Adder extends GameMod
	config(Mods);

event OnHookedActorSpawn(Object NewActor, Name Identifier)
{
	local Hat_HUDMenuSettings SettingsHUD;
	if (Identifier == 'MenuSettings')
	{
		SettingsHUD = Hat_HUDMenuSettings(NewActor);
		if (SettingsHUD != None)
			AddNewLanguages(SettingsHUD.MenuGame, GetNewLanguages());
	}
}

event OnModLoaded()
{
	HookActorSpawn(class'Hat_HUDMenuSettings', 'MenuSettings');
}

static function Array<SMenuSliderOption> GetNewLanguages()
{
	local Array<SMenuSliderOption> NewLanguages;
	local SMenuSliderOption LanguageInfo;
	LanguageInfo.LocalizedDisplayText = "Türkçe";
	LanguageInfo.PropertyValues[0] = "TUR";
	NewLanguages.AddItem(LanguageInfo);
	return NewLanguages;
}

static function AddNewLanguages(Hat_HUDMenuSettings_GameSettings SettingsObject, Array<SMenuSliderOption> NewLanguages)
{
	local int i, j, k, l;
	local bool b;
	local Hat_SMenuItem_Slider_Combo ComboSlider;
	if (SettingsObject == None || NewLanguages.Length < 1)
		return;
	for (i = 0; i < SettingsObject.Menus.Length; i++)
	{
		if (locs(SettingsObject.Menus[i].Name) != "header_singleplayer")
			continue;
		for (j = 0; j < SettingsObject.Menus[i].Items.Length; j++)
		{
			ComboSlider = Hat_SMenuItem_Slider_Combo(SettingsObject.Menus[i].Items[j]);
			if (ComboSlider == None)
				continue;
			if (ComboSlider.PropertyNames.Length <= 0 || locs(ComboSlider.PropertyNames[0]) != "engine.language")
				continue;
			for (l = 0; l < NewLanguages.Length; l++)
			{
				b = false;
				for (k = 0; k < ComboSlider.Options.Length; k++)
				{
					if (ComboSlider.Options[k].PropertyValues.Length <= 0)
						continue;
					if (locs(ComboSlider.Options[k].PropertyValues[0]) != locs(NewLanguages[l].PropertyValues[0]))
						continue;
					b = true;
					break;
				}
				if (!b)
					ComboSlider.Options.AddItem(NewLanguages[l]);
			}
		}
	}
}