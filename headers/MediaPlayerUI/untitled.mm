self.doneButton = [NSClassFromString(@"CCXNoEffectsButton") capsuleButtonWithText:@"Done"];
		self.doneButton.font = [[self class] buttonFont];
		self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:self.doneButton];
		[self.doneButton removeTarget:nil 
                   action:NULL 
         forControlEvents:UIControlEventAllEvents]; 

		[self.doneButton addTarget:self action:@selector(closeSettingsPanel) forControlEvents:UIControlEventTouchUpInside];

		[self.primaryEffectConfig configureLayerView:self.doneButton];

		if (NSClassFromString(@"LQDNightSectionController")) {
			[self.doneButton.layer setDarkModeEnabled:CFPreferencesGetAppBooleanValue((CFStringRef)@"LQDDarkModeEnabled", CFSTR("com.laughingquoll.noctis"), NULL)];
		}

		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.doneButton
		                                             attribute:NSLayoutAttributeRight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self
		                                             attribute:NSLayoutAttributeRight
		                                             multiplier:1
		                                               constant:-9]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.doneButton
		                                             attribute:NSLayoutAttributeHeight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:nil
		                                             attribute:NSLayoutAttributeNotAnAttribute
		                                             multiplier:1
		                                               constant:18]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.doneButton
		                                             attribute:NSLayoutAttributeCenterY
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self
		                                             attribute:NSLayoutAttributeCenterY
		                                             multiplier:1
		                                               constant:0]];
		self.doneButton.alpha = 0;