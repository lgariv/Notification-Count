#pragma mark Headers

@interface NCNotificationListSectionHeaderView : UIView
@property (nonatomic,copy) NSString * title;
-(void)_layoutHeaderTitleView;
-(void)_updateHeaderTitleViewWithLegibilitySettings:(id)arg1;
@end

@interface NCNotificationListView : UIScrollView
@property (retain, nonatomic) NSMutableDictionary *visibleViews;
@property (nonatomic,retain) NCNotificationListSectionHeaderView * headerView;
@property (nonatomic,readonly) unsigned long long count;
-(void)reloadHeaderView;
@end

#pragma mark Hooks

%hook NCNotificationListView
-(void)_updateStoredVisibleViewsForViewInsertedAtIndex:(unsigned long long)arg1 {
    %orig;
    if ([self.superview isKindOfClass:[%c(NCNotificationListView) class]])
        [[(NCNotificationListView*)self.superview headerView] _layoutHeaderTitleView];
    if ([self.headerView isKindOfClass:[%c(NCNotificationListSectionHeaderView) class]])
        if ([self.headerView.title containsString:@"Notification"]) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                unsigned long long notificationCount = 0;
                for (NCNotificationListView *listView in [self.visibleViews allValues])
                    notificationCount += [listView count];
                [self.headerView setTitle:[NSString stringWithFormat:@"%lld Notifications",notificationCount]];
                [self.headerView setNeedsLayout];
            });
        }
}

-(void)_updateStoredVisibleViewsForViewRemovedAtIndex:(unsigned long long)arg1 {
    %orig;
    if ([self.superview isKindOfClass:[%c(NCNotificationListView) class]])
        [[(NCNotificationListView*)self.superview headerView] _layoutHeaderTitleView];
    if ([self.headerView isKindOfClass:[%c(NCNotificationListSectionHeaderView) class]])
        if ([self.headerView.title containsString:@"Notification"]) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                unsigned long long notificationCount = 0;
                for (NCNotificationListView *listView in [self.visibleViews allValues])
                    notificationCount += [listView count];
                [self.headerView setTitle:[NSString stringWithFormat:@"%lld Notifications",notificationCount]];
                [self.headerView setNeedsLayout];
            });
        }
}
%end

%hook NCNotificationListSectionHeaderView
-(void)_layoutHeaderTitleView {
    %orig;
    if ([self.title containsString:@"Notification"]) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            unsigned long long notificationCount = 0;
            for (NCNotificationListView *listView in [[(NCNotificationListView*)self.superview visibleViews] allValues])
                notificationCount += [listView count];
            [self setTitle:[NSString stringWithFormat:@"%lld Notifications",notificationCount]];
            [self setNeedsLayout];
        });
    }
}
%end