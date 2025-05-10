//Require standard library
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <Foundation/Foundation.h>
//Imgui library
#import "Esp/CaptainHook.h"
#import "Esp/ImGuiDrawView.h"
#import "IMGUI/imgui.h"
#import "IMGUI/imgui_impl_metal.h"
#import "IMGUI/zzz.h"
//Patch library
#import "5Toubun/NakanoIchika.h"
#import "5Toubun/NakanoNino.h"
#import "5Toubun/NakanoMiku.h"
#import "5Toubun/NakanoYotsuba.h"
#import "5Toubun/NakanoItsuki.h"
#import "5Toubun/dobby.h"
#import "5Toubun/il2cpp.h"

//font
#import "RobotoRegular.h"

//macros
#define HOOK(a, b, c) DobbyHook((void*)getRealOffset(a), (void*)b, (void**)&c)

#define kScale [UIScreen mainScreen].scale
#define patch_NULL(a, b) vm(ENCRYPTOFFSET(a), strtoul(ENCRYPTHEX(b), nullptr, 0))
#define patch(a, b) vm_unity(ENCRYPTOFFSET(a), strtoul(ENCRYPTHEX(b), nullptr, 0))


@interface ImGuiDrawView () <MTKViewDelegate>
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@end

@implementation ImGuiDrawView

//Globals

bool fovSlider = false;
float fovAmount = 68.0f;

bool CanJumpFunction = false;

bool UpdateAFKManagerFunction = false;

//Methods

//Pointers

//Hooks

void (*old_fieldOfView)(void* instance, float value);
void fieldOfView(void* instance, float value) {
    if (instance != nullptr && fovSlider) {
        value = fovAmount;
    }
    return old_fieldOfView(instance, value);
}

bool (*old_CanJump)(void* instance);
bool CanJump(void* instance) {
    if (instance != nullptr) {
        if (CanJumpFunction) {
            return true;
        }
    }
    return old_CanJump(instance);
}

void (*old_UpdateAFKManager)(void* instance);
void UpdateAFKManager(void* instance) {
    if (UpdateAFKManagerFunction) {
        return;
    }
    old_UpdateAFKManager(instance);
}

void loadHooks() {
    HOOK(0x42DF2C4, fieldOfView, old_fieldOfView);
	HOOK(0x3D04BC8, CanJump, old_CanJump);
	HOOK(0x30C78E4, UpdateAFKManager, old_UpdateAFKManager);
}

void setup(){
    Il2CppAttach();
    IL2CPP::il2cpp_thread_attach(IL2CPP::il2cpp_domain_get());
    
	loadHooks();
}


static bool MenDeal = true;


- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];

    if (!self.device) abort();
    setup();
    
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;

    ImGuiStyle& style = ImGui::GetStyle();
	ImVec4* colors = style.Colors;

	colors[ImGuiCol_WindowBg]           = ImVec4(0.10f, 0.10f, 0.10f, 1.00f);
	colors[ImGuiCol_ChildBg]            = ImVec4(0.15f, 0.15f, 0.15f, 1.00f);
	colors[ImGuiCol_PopupBg]            = ImVec4(0.12f, 0.12f, 0.12f, 1.00f);

	colors[ImGuiCol_Border]             = ImVec4(0.25f, 0.25f, 0.25f, 0.50f);
	colors[ImGuiCol_Separator]          = ImVec4(0.28f, 0.28f, 0.28f, 1.00f);

	colors[ImGuiCol_Text]               = ImVec4(0.95f, 0.96f, 0.98f, 1.00f);
	colors[ImGuiCol_TextDisabled]       = ImVec4(0.50f, 0.50f, 0.50f, 1.00f);

	colors[ImGuiCol_Header]             = ImVec4(0.20f, 0.22f, 0.27f, 1.00f);
	colors[ImGuiCol_HeaderHovered]      = ImVec4(0.35f, 0.40f, 0.50f, 1.00f);
	colors[ImGuiCol_HeaderActive]       = ImVec4(0.25f, 0.30f, 0.40f, 1.00f);

	colors[ImGuiCol_Button]             = ImVec4(0.20f, 0.25f, 0.30f, 1.00f);
	colors[ImGuiCol_ButtonHovered]      = ImVec4(0.35f, 0.40f, 0.45f, 1.00f);
	colors[ImGuiCol_ButtonActive]       = ImVec4(0.15f, 0.20f, 0.25f, 1.00f);

	colors[ImGuiCol_FrameBg]            = ImVec4(0.18f, 0.18f, 0.18f, 1.00f);
	colors[ImGuiCol_FrameBgHovered]     = ImVec4(0.25f, 0.25f, 0.25f, 1.00f);
	colors[ImGuiCol_FrameBgActive]      = ImVec4(0.20f, 0.20f, 0.20f, 1.00f);

	colors[ImGuiCol_Tab]                = ImVec4(0.15f, 0.18f, 0.22f, 1.00f);
	colors[ImGuiCol_TabHovered]         = ImVec4(0.38f, 0.50f, 0.64f, 1.00f);
	colors[ImGuiCol_TabActive]          = ImVec4(0.28f, 0.35f, 0.48f, 1.00f);
	colors[ImGuiCol_TabUnfocused]       = ImVec4(0.15f, 0.18f, 0.22f, 1.00f);
	colors[ImGuiCol_TabUnfocusedActive] = ImVec4(0.20f, 0.25f, 0.30f, 1.00f);

	colors[ImGuiCol_TitleBg]            = ImVec4(0.12f, 0.12f, 0.12f, 1.00f);
	colors[ImGuiCol_TitleBgActive]      = ImVec4(0.15f, 0.20f, 0.25f, 1.00f);
	colors[ImGuiCol_TitleBgCollapsed]   = ImVec4(0.08f, 0.08f, 0.08f, 1.00f);

	colors[ImGuiCol_ScrollbarBg]        = ImVec4(0.02f, 0.02f, 0.02f, 0.39f);
	colors[ImGuiCol_ScrollbarGrab]      = ImVec4(0.20f, 0.25f, 0.30f, 1.00f);
	colors[ImGuiCol_ScrollbarGrabHovered]= ImVec4(0.25f, 0.30f, 0.35f, 1.00f);
	colors[ImGuiCol_ScrollbarGrabActive]= ImVec4(0.30f, 0.35f, 0.40f, 1.00f);

	ImGui::GetStyle().WindowPadding     = ImVec2(20, 20);
	ImGui::GetStyle().FramePadding      = ImVec2(10, 10);
	ImGui::GetStyle().ItemSpacing       = ImVec2(10, 10);
	ImGui::GetStyle().ItemInnerSpacing  = ImVec2(8, 8);

	ImGui::GetStyle().WindowRounding    = 10.0f;
	ImGui::GetStyle().FrameRounding     = 8.0f;
	ImGui::GetStyle().GrabRounding      = 8.0f;
	ImGui::GetStyle().TabRounding       = 8.0f;
	
	ImFontConfig font_cfg;
	font_cfg.FontDataOwnedByAtlas = false;
	ImGui::GetIO().Fonts->AddFontFromMemoryTTF(RobotoRegular, sizeof(RobotoRegular), 17, &font_cfg);
    

    
    ImGui_ImplMetal_Init(_device);

    return self;
}

+ (void)showChange:(BOOL)open
{
    MenDeal = open;
}

- (MTKView *)mtkView
{
    return (MTKView *)self.view;
}

- (void)loadView
{

 

    CGFloat w = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width;
    CGFloat h = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height;
    self.view = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.mtkView.clipsToBounds = YES;

}



#pragma mark - Interaction

- (void)updateIOWithTouchEvent:(UIEvent *)event
{
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);

    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches)
    {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled)
        {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

#pragma mark - MTKViewDelegate

- (void)drawInMTKView:(MTKView*)view
{
   
    
    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;

    CGFloat framebufferScale = view.window.screen.scale ?: UIScreen.mainScreen.scale;
    io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    io.DeltaTime = 1 / float(view.preferredFramesPerSecond ?: 120);
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    

		if (MenDeal == true) {
            [self.view setUserInteractionEnabled:YES];
        } else if (MenDeal == false) {
            [self.view setUserInteractionEnabled:NO];
        }

        MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
        if (renderPassDescriptor != nil)
        {
            id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
            [renderEncoder pushDebugGroup:@"ImGui Jane"];

            ImGui_ImplMetal_NewFrame(renderPassDescriptor);
            ImGui::NewFrame();
            
            ImFont* font = ImGui::GetFont();
            font->Scale = 15.f / font->FontSize;
            
            CGFloat x = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width) - 360) / 2;
            CGFloat y = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height) - 300) / 2;
            
            ImGui::SetNextWindowPos(ImVec2(x, y), ImGuiCond_FirstUseEver);
            ImGui::SetNextWindowSize(ImVec2(500, 400), ImGuiCond_FirstUseEver);
            
			if (MenDeal == true)
			{
					
            ImGui::Begin("Fall Guys v18.0.0 | made with love by @iosdevice");

			if (ImGui::BeginTabBar("MainTabBar")) {
			
			if (ImGui::BeginTabItem("Player")) {
			
			ImGui::Checkbox("Air Jump", &CanJumpFunction);
			
			ImGui::EndTabItem();
			}
			
			if (ImGui::BeginTabItem("Misc")) {
			
			ImGui::Checkbox("FOV", &fovSlider);
                if (fovSlider) {
                    ImGui::SliderFloat("##fovAmountSlider", &fovAmount, 60.0f, 120.0f);
                }

                        ImGui::Checkbox("AFK Disabler", &UpdateAFKManagerFunction);
			
			ImGui::EndTabItem();
			}
			
			ImGui::EndTabBar();
			}

			ImGui::End();
                
            }
            ImDrawList* draw_list = ImGui::GetBackgroundDrawList();



            ImGui::Render();
            ImDrawData* draw_data = ImGui::GetDrawData();
            ImGui_ImplMetal_RenderDrawData(draw_data, commandBuffer, renderEncoder);
          
            [renderEncoder popDebugGroup];
            [renderEncoder endEncoding];

            [commandBuffer presentDrawable:view.currentDrawable];
        }

        [commandBuffer commit];
}

- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size
{
    
}

@end
