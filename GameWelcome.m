//
//  GameWelcome.m
//  ShootingGame1-UI Flow
//
//  Created by Chalermchon Samana on 2/17/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameWelcome.h"
#import "SoundManager.h"
#import "SpaceParallaxBackground.h"
#import "GameScene.h"
#import "AppDelegate.h"
#import "GameCenterHelper.h"

enum{
    TAG_PLAY        = 0,
    TAG_FB_MODE     = 1,
    TAG_ABOUT       = 2,
    TAG_CLOSE_ABOUT = 3,
    TAG_LOGO_MENU   = 99
};

@interface GameWelcome(){
    SpaceParallaxBackground *plxBg;
    CCSprite *logo,*about;
    BOOL action;
}

@end

@implementation GameWelcome

+(CCScene*)scene{
    
    CCScene *scene = [CCScene node];
    GameWelcome *game = [GameWelcome node];
    [scene addChild:game];
    
    return scene;
}

-(id)init{
    if(self=[super init]){
        
        //BG
        plxBg = [SpaceParallaxBackground node];
        [plxBg backgroundStart];
        [self addChild:plxBg];
        
        //sound
        [SoundManager playSound:SOUND_BG volume:SOUND_BG_VOLUME_MIN];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        ///////////////////////////// menu in background /////////////////////////////////
        //right : game center
        CCMenu *rightMenu = [CCMenu node];
        NSArray *listRMName = @[@"gamecenter_icon_1.png",@"gamecenter_icon_2.png"];
        for(int i=0;i<listRMName.count;i++){
            CCSprite *m = [CCSprite spriteWithSpriteFrameName:listRMName[i]];
            CCSprite *m2 = [CCSprite spriteWithSpriteFrameName:listRMName[i]];
            CCMenuItemSprite *menuItem = [CCMenuItemSprite itemWithNormalSprite:m
                                                                 selectedSprite:m2
                                                                         target:self
                                                                       selector:@selector(onBGMenuClick:)];
            [menuItem setScale:0.5];
            [menuItem setTag:i];
            [rightMenu addChild:menuItem];
        }
        
        [rightMenu alignItemsInColumns:@2, nil];
        [rightMenu alignItemsVerticallyWithPadding:30];
        [rightMenu setPosition:ccp(winSize.width-80, 200)];
        [self addChild:rightMenu];
        
        
        
        
        ////////////////////////////// label Logo ////////////////////////////////////////
        logo = [CCSprite spriteWithSpriteFrameName:@"sp-logo.png"];
        [logo setPosition:ccp(winSize.width/2,winSize.height/2+80)];
        [self addChild:logo];
        
        CCMenu *menu = [CCMenu node];
        
        NSArray *listName = @[@"btn-play-1.png",@"btn-play-2.png",@"f-button-login.png",@"f-button-login.png",@"btn-about-1.png",@"btn-about-2.png"];
        int tag[] = {TAG_PLAY,TAG_FB_MODE,TAG_ABOUT};
        for(int i=0;i<listName.count/2;i++){
            CCSprite *m1 = [CCSprite spriteWithSpriteFrameName:listName[i*2]];
            CCSprite *m2 = [CCSprite spriteWithSpriteFrameName:listName[i*2+1]];;
            CCMenuItemImage *menuItem = [CCMenuItemImage itemWithNormalSprite:m1
                                                               selectedSprite:m2
                                                                       target:self
                                                                     selector:@selector(onMenuClick:)];
            if(i>1) [menuItem setScale:0.6];
            
            [menuItem setTag:tag[i]];
            [menu addChild:menuItem];
        }
        
        [menu alignItemsInColumns:@3,nil];
        [menu alignItemsVerticallyWithPadding:20];
        [menu setPosition:ccp(logo.boundingBox.size.width/2, -115)];
        [menu setTag:TAG_LOGO_MENU];
        [logo addChild:menu];
        
        /////////////////////////////// label about //////////////////////////////////////////
        about = [CCSprite spriteWithSpriteFrameName:@"sp-page-about.png"];
        [about setPosition:ccp(winSize.width/2,-about.boundingBox.size.height/2)];
        [self addChild:about];
        
        CCMenuItemImage *aMenuItem = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn-close-1.png"]
                                                            selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn-close-2.png"]
                                                                    target:self
                                                                  selector:@selector(onMenuClick:)];
        [aMenuItem setScale:0.6];
        [aMenuItem setTag:TAG_CLOSE_ABOUT];
        
        CCMenu *aMenu = [CCMenu menuWithItems:aMenuItem, nil];
        [aMenu setPosition:ccp(about.boundingBox.size.width/2,-40)];
        [about addChild:aMenu];
        
        
        //////////////// facebook //////////////////
        //#Facebook add facebook observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbSessionStateChanged:) name:FBSessionStateChangedNotification object:nil];
        
        //#Facebook session check ...
        AppController *appDelegate = (AppController*)[[UIApplication sharedApplication] delegate];
        [appDelegate openSessionWithAllowLoginUI:NO];//check session not show UI
        
        
        
    }
    
    return self;
}

-(void)onExit{
    [super onExit];
    NSLog(@"onExit");
    [[NSNotificationCenter defaultCenter] removeObserver:self]; 
}

-(void)onMenuClick:(CCMenuItemImage*)menu{
    if(!action){
        [SoundManager playSound:SOUND_BEEP];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        switch (menu.tag) {
            case 0:{//play
                //stop
                [SoundManager stopSoundBG];
                [plxBg backgroundStop];
                
                //trans page
                CCTransitionSplitCols *transition = [CCTransitionSplitCols transitionWithDuration:0.5 scene:[GameScene scene]];
                [[CCDirector sharedDirector] replaceScene:transition];
                
                break;
            }
            //#Facebook example login & logout facebook
            case 1:{//login & play facebook mode
                
                //facebook #ark to login ask
                AppController *appDelegate = (AppController*)[[UIApplication sharedApplication] delegate];
                // The user has initiated a login, so call the openSession method
                // and show the login UX if necessary.
                //[appDelegate openSessionWithAllowLoginUI:YES];
                
                // If the user is authenticated, log out when the button is clicked.
                // If the user is not authenticated, log in when the button is clicked.
                if (FBSession.activeSession.isOpen) {
                    //[appDelegate closeSession]; //#Facebook Logout / close session logout
                    
                    //play fb mode
                    NSLog(@"play with facebook mode...");
                    
                } else {
                    // The user has initiated a login, so call the openSession method
                    // and show the login UX if necessary.
                    [appDelegate openSessionWithAllowLoginUI:YES];
                }
                
                break;
            }
            case 2:{//about
                action = YES;
                
                CCMoveTo *moveUp = [CCMoveTo actionWithDuration:1 position:ccp(logo.position.x,winSize.height+logo.boundingBox.size.height*1.5)];
                [logo runAction:moveUp];
                
                CCMoveTo *moveUp2 = [CCMoveTo actionWithDuration:1 position:ccp(about.position.x,winSize.height/2)];
                CCSequence *seq2 = [CCSequence actions:moveUp2,[CCCallFuncN actionWithTarget:self selector:@selector(endMove)], nil];
                [about runAction:seq2];
                
                break;
            }
            case TAG_CLOSE_ABOUT:{//close about
                action = YES;
                
                CCMoveTo *moveDown = [CCMoveTo actionWithDuration:1 position:ccp(logo.position.x,winSize.height/2+80)];
                [logo runAction:moveDown];
                
                CCMoveTo *moveDown2 = [CCMoveTo actionWithDuration:1 position:ccp(about.position.x,-about.boundingBox.size.height/2)];
                CCSequence *seq2 = [CCSequence actions:moveDown2,[CCCallFuncN actionWithTarget:self selector:@selector(endMove)], nil];
                [about runAction:seq2];
                
                break;
            }
        }
    }
    
}

-(void)onBGMenuClick:(CCMenuItemSprite*)menuItem{
    switch (menuItem.tag) {
        case 0:{//achievement
            [self showAchievements];
            break;
        }
        case 1:{//leader board
            [self showLeaderBoard];
            break;
        }
    }
}

-(void)endMove{
    action = NO;
}

//////////////////////////// Game Center ViewController Show /////////////////////////
-(void)showAchievements{
    AppController *delegate = (AppController*)[UIApplication sharedApplication].delegate;
        
    GKAchievementViewController *achViewController = [[GKAchievementViewController alloc] init];
    
    if(achViewController!=NULL){
        achViewController.achievementDelegate = self;
        [delegate.navController presentModalViewController:achViewController animated:YES];
    }

   
}

-(void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController{
    AppController *delegate = (AppController*)[UIApplication sharedApplication].delegate;
    
    [delegate.navController dismissModalViewControllerAnimated:YES];
    [viewController release];
}

-(void)showLeaderBoard{
    AppController *delegate = (AppController*)[UIApplication sharedApplication].delegate;
    
    GKLeaderboardViewController *leaderBoardViewController = [[GKLeaderboardViewController alloc] init];
    
    if(leaderBoardViewController!=NULL){
        leaderBoardViewController.leaderboardDelegate = self;
        [delegate.navController presentModalViewController:leaderBoardViewController animated:YES];
    }
}

-(void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController{
    AppController *delegate = (AppController*)[UIApplication sharedApplication].delegate;
    
    [delegate.navController dismissModalViewControllerAnimated:YES];
    [viewController release];
}

////////////////////////////////////// Facebook Notification ////////////////////////////
//#Facebook recieve facebook state changed notification
-(void)fbSessionStateChanged:(NSNotification*)notification{
    
    if (FBSession.activeSession.isOpen) {
        NSLog(@"state open");
        CCMenu *lgMenu = (CCMenu*)[logo getChildByTag:TAG_LOGO_MENU];
        CCMenuItemSprite *spItem = (CCMenuItemSprite*)[lgMenu getChildByTag:TAG_FB_MODE];
        [spItem setNormalImage:[CCSprite spriteWithSpriteFrameName:@"f-button-play.png"]];
        [spItem setSelectedImage:[CCSprite spriteWithSpriteFrameName:@"f-button-play.png"]];
    }else{
        NSLog(@"state close");
        CCMenu *lgMenu = (CCMenu*)[logo getChildByTag:TAG_LOGO_MENU];
        CCMenuItemSprite *spItem = (CCMenuItemSprite*)[lgMenu getChildByTag:TAG_FB_MODE];
        [spItem setNormalImage:[CCSprite spriteWithSpriteFrameName:@"f-button-login.png"]];
        [spItem setSelectedImage:[CCSprite spriteWithSpriteFrameName:@"f-button-login.png"]];
    }

    
}


@end
