let searchData = null;
let searchPromise = null;
let activeIndex = -1; // 当前选中的索引

// 1. 异步加载数据
async function loadSearchData() {
    if (searchData) return searchData;
    if (!searchPromise) {
        const url = window.SEARCH_JSON_URL || '/z-search.json';
        searchPromise = fetch(url)
            .then(res => res.json())
            .then(data => {
                searchData = data;
                return data;
            })
            .catch(err => {
                console.error("Search data failed:", err);
                return [];
            });
    }
    return searchPromise;
}

// 2. 执行搜索与渲染
async function performSearch(query) {
    const resultsContainer = document.getElementById('searchResults');
    const queryTrimmed = query.trim();

    if (!queryTrimmed || queryTrimmed.length < 2) {
        resultsContainer.innerHTML = '';
        activeIndex = -1;
        return;
    }

    const data = await loadSearchData();
    const queryLower = queryTrimmed.toLowerCase();

    const matches = data.filter(item =>
        (item.title || "").toLowerCase().includes(queryLower) ||
        (item.content || "").toLowerCase().includes(queryLower)
    );

    if (matches.length === 0) {
        resultsContainer.innerHTML = `
            <div class="search-stats">0 matching documents</div>
            <div class="search-no-results">No results found</div>
        `;
        activeIndex = -1;
        return;
    }

    // 构造结果 HTML
    const resultsHtml = matches.map(item => {
        const highlightedTitle = highlight(item.title, queryTrimmed);
        const content = item.content || "";
        const contentLower = content.toLowerCase();

        // 查找所有匹配位置并分组
        let locations = [];
        let pos = contentLower.indexOf(queryLower);
        while (pos !== -1) {
            locations.push(pos);
            pos = contentLower.indexOf(queryLower, pos + queryLower.length);
        }

        let snippetsHtml = "";
        if (locations.length > 0) {
            let groups = [];
            let currentGroup = [locations[0]];
            for (let i = 1; i < locations.length; i++) {
                if (locations[i] - locations[i-1] < 150) {
                    currentGroup.push(locations[i]);
                } else {
                    groups.push(currentGroup);
                    currentGroup = [locations[i]];
                }
            }
            groups.push(currentGroup);

            // 每个片段现在都是一个可点击的 .selectable-item
            snippetsHtml = groups.map(group => {
                const start = Math.max(0, group[0] - 50);
                const end = Math.min(content.length, group[group.length - 1] + 100);
                let text = (start > 0 ? "..." : "") + content.slice(start, end) + (end < content.length ? "..." : "");
                return `
                    <div class="selectable-item snippet-item" data-url="${item.url}" onclick="window.location.href='${item.url}'">
                        ${highlight(text, queryTrimmed)}
                    </div>`;
            }).join('');
        } else {
            snippetsHtml = `
                <div class="selectable-item snippet-item" data-url="${item.url}" onclick="window.location.href='${item.url}'">
                    ${content.substring(0, 150)}...
                </div>`;
        }

        return `
            <div class="search-result-group">
                <div class="result-group-header">
                    <i class="fa-regular fa-file-lines"></i>
                    <span class="group-title">${highlightedTitle}</span>
                </div>
                <div class="result-snippets-list">
                    ${snippetsHtml}
                </div>
            </div>
        `;
    }).join('');

    resultsContainer.innerHTML = `
        <div class="search-stats">${matches.length} matching documents</div>
        <div class="search-results-list" id="scrollContainer">
            ${resultsHtml}
        </div>
    `;

    // 重置选中状态
    activeIndex = -1;
}

// 高亮函数
function highlight(text, query) {
    if (!text) return "";
    const escapedQuery = query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    const regex = new RegExp(`(${escapedQuery})`, 'gi');
    return text.replace(regex, '<mark>$1</mark>');
}

// 更新选中样式的辅助函数
function updateSelection(items) {
    items.forEach((item, index) => {
        if (index === activeIndex) {
            item.classList.add('active');
            // 确保选中项在可见区域
            item.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
        } else {
            item.classList.remove('active');
        }
    });
}

// 3. UI 控制
async function toggleSearch() {
    const modal = document.getElementById('searchModal');
    if (!modal) return;
    modal.classList.add('open');
    const input = document.getElementById('searchInput');
    if (input) {
        input.value = '';
        input.focus();
    }
    document.getElementById('searchResults').innerHTML = '';
    document.body.style.overflow = 'hidden';
    await loadSearchData();
}

function closeSearch() {
    const modal = document.getElementById('searchModal');
    if (modal) modal.classList.remove('open');
    document.body.style.overflow = '';
}

// 4. 事件绑定
document.addEventListener('DOMContentLoaded', () => {
    const searchInput = document.getElementById('searchInput');

    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            performSearch(e.target.value);
        });

        searchInput.addEventListener('keydown', (e) => {
            const items = document.querySelectorAll('.selectable-item');
            if (items.length === 0) return;

            if (e.key === 'ArrowDown') {
                e.preventDefault();
                activeIndex = (activeIndex + 1) % items.length;
                updateSelection(items);
            } else if (e.key === 'ArrowUp') {
                e.preventDefault();
                activeIndex = (activeIndex - 1 + items.length) % items.length;
                updateSelection(items);
            } else if (e.key === 'Enter') {
                e.preventDefault();
                if (activeIndex >= 0) {
                    items[activeIndex].click();
                }
            }
        });
    }

    // 点击外部关闭
    const searchModal = document.getElementById('searchModal');
    if (searchModal) {
        searchModal.addEventListener('click', (e) => {
            if (e.target === searchModal) closeSearch();
        });
    }

    // Esc 键关闭
    document.addEventListener('keydown', (e) => {
        if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
            e.preventDefault();
            toggleSearch();
        }
        if (e.key === 'Escape') {
            closeSearch();
            if (typeof closeShare === 'function') closeShare();
        }
    });
});

// ========== 分享功能保持不变 ==========
function sharePost() {
  const modal = document.getElementById('shareModal');
  const url = window.location.href;
  const title = document.title;
  document.getElementById('sharePreviewTitle').textContent = title;
  document.getElementById('shareUrl').value = url;
  const ogImage = document.querySelector('meta[property="og:image"]');
  const previewImg = document.getElementById('sharePreviewImg');
  if (ogImage && ogImage.content) {
    previewImg.src = ogImage.content;
    previewImg.style.display = 'block';
  } else {
    previewImg.style.display = 'none';
  }
  const encodedUrl = encodeURIComponent(url);
  const encodedTitle = encodeURIComponent(title);
  document.getElementById('shareLinkedIn').href = `https://www.linkedin.com/sharing/share-offsite/?url=${encodedUrl}`;
  document.getElementById('shareTwitter').href = `https://twitter.com/intent/tweet?url=${encodedUrl}&text=${encodedTitle}`;
  document.getElementById('shareWhatsApp').href = `https://wa.me/?text=${encodedTitle}%20${encodedUrl}`;
  document.getElementById('shareFacebook').href = `https://www.facebook.com/sharer/sharer.php?u=${encodedUrl}`;
  document.getElementById('shareEmail').href = `mailto:?subject=${encodedTitle}&body=${encodedUrl}`;
  modal.classList.add('open');
  document.body.style.overflow = 'hidden';
}

function closeShare() {
  const modal = document.getElementById('shareModal');
  if (modal) modal.classList.remove('open');
  document.body.style.overflow = '';
}

function copyUrl() {
  const urlInput = document.getElementById('shareUrl');
  urlInput.select();
  navigator.clipboard.writeText(urlInput.value).then(() => {
    const btn = document.querySelector('.copy-btn');
    const originalText = btn.innerHTML;
    btn.innerHTML = '<i class="fa fa-check"></i> Copied!';
    btn.style.background = '#28a745';
    setTimeout(() => {
      btn.innerHTML = originalText;
      btn.style.background = '';
    }, 2000);
  });
}