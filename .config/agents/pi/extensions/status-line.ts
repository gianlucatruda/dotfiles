import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { truncateToWidth } from "@earendil-works/pi-tui";
import { basename } from "node:path";

const separator = " · ";

function formatTokens(tokens: number): string {
	if (tokens < 1_000) return String(tokens);
	if (tokens < 10_000) return `${(tokens / 1_000).toFixed(1)}k`;
	if (tokens < 1_000_000) return `${Math.round(tokens / 1_000)}k`;
	return `${(tokens / 1_000_000).toFixed(1)}M`;
}

export default function (pi: ExtensionAPI) {
	let dirty: number | undefined;

	pi.on("session_start", (_event, ctx) => {
		let requestRender = () => {};
		const refreshDirty = async () => {
			const result = await pi.exec("git", ["status", "--porcelain"], { timeout: 1_000 });
			dirty = result.code === 0 ? result.stdout.split("\n").filter(Boolean).length : undefined;
			requestRender();
		};

		pi.on("tool_execution_end", () => void refreshDirty());
		ctx.ui.setFooter((tui, theme, footerData) => {
			requestRender = () => tui.requestRender();
			return {
				dispose: footerData.onBranchChange(requestRender),
				invalidate() {},
				render(width) {
				const model = ctx.model?.id ?? "no-model";
				const effort = ctx.thinkingLevel ?? "off";
				const branch = footerData.getGitBranch();
				const git = branch && `${branch}${dirty ? `±${dirty}` : ""}`;
				const context = ctx.getContextUsage();
				const percent = context?.percent;
				const contextColor = percent === null || percent === undefined
					? "dim"
					: percent >= 85 ? "error" : percent >= 60 ? "warning" : "success";
				const contextText = percent === null || percent === undefined
					? "? ctx"
					: `${Math.floor(percent)}% ctx`;
				let tokens = 0;
				for (const entry of ctx.sessionManager.getEntries()) {
					if (entry.type === "message" && entry.message.role === "assistant") {
						tokens += entry.message.usage.totalTokens;
					}
				}
				const used = `${formatTokens(tokens)} used`;

				const parts = [
					theme.fg("mdCode", model),
					theme.fg("dim", effort),
					theme.fg("mdLink", basename(ctx.cwd)),
					git && theme.fg("customMessageLabel", git),
					theme.fg(contextColor, contextText),
					theme.fg("dim", used),
				].filter((part): part is string => Boolean(part));

					return [truncateToWidth(parts.join(theme.fg("dim", separator)), width)];
				},
			};
		});
		void refreshDirty();
	});
}
